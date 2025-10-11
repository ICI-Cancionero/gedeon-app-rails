require 'tempfile'

class OpenPdfHtmlGenerator
  # Set headless mode before any Java AWT imports
  Java::JavaLang::System.setProperty('java.awt.headless', 'true') if defined?(Java)

  java_import 'org.openpdf.text.Document'
  java_import 'org.openpdf.text.PageSize'
  java_import 'org.openpdf.text.pdf.PdfWriter'
  java_import 'org.openpdf.text.html.simpleparser.HTMLWorker'
  java_import 'java.io.ByteArrayOutputStream'
  java_import 'java.io.StringReader'

  def self.generate_pdf_from_html(html_content)
    new.generate_pdf_from_html(html_content)
  end

  def generate_pdf_from_html(html_content)
    # Ensure headless mode for Java AWT
    Java::JavaLang::System.setProperty('java.awt.headless', 'true')

    # Create a new PDF document
    document = Document.new(PageSize::A4)

    begin
      # Create a ByteArrayOutputStream to write the PDF
      output_stream = ByteArrayOutputStream.new

      # Create PdfWriter instance
      writer = PdfWriter.getInstance(document, output_stream)

      # Open the document
      document.open

      # Parse and add HTML content
      html_worker = HTMLWorker.new(document)
      string_reader = StringReader.new(html_content)
      html_worker.parse(string_reader)

      # Close the document
      document.close

      # Convert Java byte array to Ruby string
      java_bytes = output_stream.toByteArray
      ruby_bytes = String.from_java_bytes(java_bytes)

      ruby_bytes
    rescue => e
      document.close if document.isOpen
      raise e
    end
  end
end
