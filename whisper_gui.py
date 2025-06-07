import gradio as gr
import whisper
import os
import tempfile
import datetime
import re
from pathlib import Path

class WhisperGUI:
    def __init__(self):
        self.model = None
        self.current_model_name = None
        
    def load_model(self, model_name):
        """Load Whisper model if not already loaded or if different model requested"""
        if self.model is None or self.current_model_name != model_name:
            print(f"Loading Whisper model: {model_name}")
            self.model = whisper.load_model(model_name)
            self.current_model_name = model_name
            print(f"Model {model_name} loaded successfully!")
        return self.model
    
    def format_timestamp(self, seconds):
        """Convert seconds to SRT timestamp format"""
        hours = int(seconds // 3600)
        minutes = int((seconds % 3600) // 60)
        secs = int(seconds % 60)
        millisecs = int((seconds % 1) * 1000)
        return f"{hours:02d}:{minutes:02d}:{secs:02d},{millisecs:03d}"
    
    def generate_srt(self, segments):
        """Generate SRT content from whisper segments"""
        srt_content = ""
        for i, segment in enumerate(segments):
            start_time = self.format_timestamp(segment['start'])
            end_time = self.format_timestamp(segment['end'])
            text = segment['text'].strip()
            
            srt_content += f"{i + 1}\n"
            srt_content += f"{start_time} --> {end_time}\n"
            srt_content += f"{text}\n\n"
        
        return srt_content
    
    def generate_txt(self, segments):
        """Generate plain text from whisper segments"""
        return "\n".join([segment['text'].strip() for segment in segments])
    
    def transcribe_audio(self, audio_file, audio_record, model_name, progress=gr.Progress()):
        """Main transcription function for audio and video files"""
        # Check if either input is provided
        if audio_file is None and audio_record is None:
            return "Please upload an audio/video file or record audio first.", None, None, ""
        
        # Determine which input to use (prioritize file upload over recording)
        if audio_file is not None:
            input_source = audio_file
            source_type = "uploaded file"
        else:
            input_source = audio_record
            source_type = "recorded audio"
        
        try:
            progress(0.1, desc="Loading model...")
            model = self.load_model(model_name)
            
            progress(0.3, desc=f"Processing {source_type}...")
            # Get the file path from the input source
            file_path = input_source.name if hasattr(input_source, 'name') else input_source
              # Prepare transcription options
            transcribe_options = {
                "word_timestamps": True,
                "verbose": True
            }
            
            # Note: segment_length is not a valid Whisper parameter
            # Whisper automatically segments audio based on its internal logic
            
            # Transcribe with options (Whisper can handle both audio and video files)
            result = model.transcribe(file_path, **transcribe_options)
            
            progress(0.7, desc="Generating output files...")
            
            # Get base filename without extension
            file_path_obj = Path(file_path)
            base_name = file_path_obj.stem
            
            # If it's a recorded audio, use timestamp for filename
            if audio_record is not None and audio_file is None:
                timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
                base_name = f"recorded_audio_{timestamp}"
            
            # Generate SRT content
            srt_content = self.generate_srt(result['segments'])
            
            # Generate TXT content
            txt_content = self.generate_txt(result['segments'])
            
            # Create temporary files for download
            temp_dir = tempfile.gettempdir()
            
            # SRT file
            srt_filename = f"{base_name}_transcription.srt"
            srt_path = os.path.join(temp_dir, srt_filename)
            with open(srt_path, 'w', encoding='utf-8') as f:
                f.write(srt_content)
            
            # TXT file
            txt_filename = f"{base_name}_transcription.txt"
            txt_path = os.path.join(temp_dir, txt_filename)
            with open(txt_path, 'w', encoding='utf-8') as f:
                f.write(txt_content)
            
            progress(1.0, desc="Complete!")
            
            # Return status, file paths, and preview text
            status_msg = f"✅ Transcription completed successfully!\n"
            status_msg += f"📄 Files generated:\n"
            status_msg += f"• {srt_filename}\n"
            status_msg += f"• {txt_filename}\n"
            status_msg += f"🎯 Model used: {model_name}\n"
            status_msg += f"📥 Source: {source_type}\n"
            status_msg += f"⏱️ Duration: {result.get('duration', 'Unknown')} seconds"
            
            return status_msg, srt_path, txt_path, txt_content[:1000] + "..." if len(txt_content) > 1000 else txt_content
            
        except Exception as e:
            error_msg = f"❌ Error during transcription: {str(e)}"
            print(error_msg)
            return error_msg, None, None, ""

def create_interface():
    """Create and configure the Gradio interface"""
    whisper_gui = WhisperGUI()
    with gr.Blocks(
        title="Whisper Audio Transcription",
        theme=gr.themes.Soft(),        css="""
        .gradio-container {
            max-width: 1600px !important;
            width: 95% !important;
        }
        """
    ) as demo:
        gr.Markdown("""
            # 🎙️ Whisper Audio/Video Transcription Tool
            
            **Upload** an audio/video file or **record** audio directly, then generate both **SRT** (subtitle) and **TXT** (plain text) transcriptions using OpenAI's Whisper model.
            
            **Supported formats:** 
            - **Audio:** MP3, WAV, M4A, FLAC, OGG, WMA
            - **Video:** MP4, AVI, MOV, MKV, WEBM, FLV
            - **Recording:** Direct microphone input
            """        )
        
        with gr.Row():
            # Left column - Controls
            with gr.Column(scale=1):
                # Model selection
                model_dropdown = gr.Dropdown(
                    choices=["tiny", "small", "medium", "large"],
                    value="tiny",
                    label="🤖 Whisper Model",
                    info="Tiny: Fastest, less accurate | Small: Slower, more accurate | Medium: Balanced | Large: Slowest, most accurate"
                )
                
                # Audio/Video input
                audio_input = gr.File(
                    label="📁 Upload Audio/Video File",
                    file_types=["audio", "video"],
                    file_count="single"
                )
                
                # Audio recording
                audio_record = gr.Audio(
                    label="🎤 Record Audio",
                    sources=["microphone"],
                    type="filepath"                )
                
                gr.Markdown("*Note: Use either file upload OR audio recording, not both*")
                
                # Transcribe button
                transcribe_btn = gr.Button(
                    "🎯 Start Transcription",
                    variant="primary",
                    size="lg"
                )
            
            # Right column - Results
            with gr.Column(scale=2):
                # Status output
                status_output = gr.Textbox(
                    label="📊 Status",
                    lines=6,
                    interactive=False
                )
                
                # Preview
                preview_output = gr.Textbox(
                    label="👀 Text Preview",
                    lines=8,
                    interactive=False,
                    placeholder="Transcribed text will appear here..."
                )
                
                # File downloads
                with gr.Row():
                    srt_download = gr.File(
                        label="📄 Download SRT File",
                        visible=True,
                        scale=1
                    )
                    txt_download = gr.File(
                        label="📄 Download TXT File",
                        visible=True,
                        scale=1                )

        # Event handlers
        transcribe_btn.click(
            fn=whisper_gui.transcribe_audio,
            inputs=[audio_input, audio_record, model_dropdown],
            outputs=[status_output, srt_download, txt_download, preview_output],
            show_progress=True
        )
    
    return demo

if __name__ == "__main__":
    print("🚀 Starting Whisper GUI...")
    print("📦 Loading interface...")
    
    # Create and launch the interface
    demo = create_interface()
    
    print("🌐 Launching web interface...")
    demo.launch(
        server_name="127.0.0.1",
        server_port=7860,
        share=False,
        show_error=True,
    )