class Ckeditor::PicturesController < Ckeditor::ApplicationController
  def index
    @pictures = Ckeditor::Picture.all
  end

  def create
    begin
      @picture = Ckeditor::Picture.new
      @picture.data = params[:upload] if params[:upload].present?
      
      if @picture.save
        # Return the response in the format CKEditor expects
        render html: "<script type='text/javascript'>
          window.parent.CKEDITOR.tools.callFunction(#{params[:CKEditorFuncNum]}, '#{@picture.url}');
        </script>".html_safe
      else
        # Return error response
        render html: "<script type='text/javascript'>
          window.parent.CKEDITOR.tools.callFunction(#{params[:CKEditorFuncNum]}, '', '#{@picture.errors.full_messages.join(', ')}');
        </script>".html_safe
      end
    rescue => e
      Rails.logger.error "CKEditor upload error: #{e.message}"
      # Return error response
      render html: "<script type='text/javascript'>
        window.parent.CKEDITOR.tools.callFunction(#{params[:CKEditorFuncNum]}, '', 'Upload failed: #{e.message}');
      </script>".html_safe
    end
  end

  def destroy
    @picture = Ckeditor::Picture.find(params[:id])
    @picture.destroy
    redirect_to ckeditor_pictures_path
  end

  private

  def picture_params
    params.permit(:upload, :CKEditor, :CKEditorFuncNum, :langCode)
  end
end