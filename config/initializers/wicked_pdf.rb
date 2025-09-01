# WickedPDF Global Configuration
#
# Use this to set up shared configuration options for your entire application.
# Any of the configuration options shown here can also be applied to single
# models by passing arguments to the `render :pdf` call.
#
# To learn more, check out the README:
#
# https://github.com/mileszs/wicked_pdf/blob/master/README.md

WickedPdf.config = {
  # Prefer an explicit path (e.g., in Docker) and fall back to gem binary locally
  exe_path: (
    ENV['WKHTMLTOPDF_PATH'].presence ||
      begin
        Gem.bin_path('wkhtmltopdf-binary-edge', 'wkhtmltopdf')
      rescue StandardError
        begin
          Gem.bin_path('wkhtmltopdf-binary', 'wkhtmltopdf')
        rescue StandardError
          nil
        end
      end
  )

  # Layout file to be used for all PDFs
  # (but can be overridden in `render :pdf` calls)
  # layout: 'pdf.html',
}
