require 'tempfile'

class OpenPdfHtmlGenerator
  # Set headless mode before any Java AWT imports
  Java::JavaLang::System.setProperty('java.awt.headless', 'true') if defined?(Java)

  java_import 'org.openpdf.pdf.ITextRenderer'
  java_import 'java.io.ByteArrayOutputStream'
  java_import 'java.io.StringReader'
  java_import 'javax.xml.parsers.DocumentBuilderFactory'
  java_import 'org.w3c.dom.Document'
  java_import 'org.xml.sax.InputSource'

  def self.generate_pdf_from_html(html_content)
    new.generate_pdf_from_html(html_content)
  end

  def generate_pdf_from_html(html_content)
    # Ensure headless mode for Java AWT
    Java::JavaLang::System.setProperty('java.awt.headless', 'true')

    begin
      # Create a ByteArrayOutputStream to write the PDF
      output_stream = ByteArrayOutputStream.new

      # Create a DocumentBuilderFactory with relaxed security
      doc_builder_factory = DocumentBuilderFactory.newInstance
      doc_builder_factory.setNamespaceAware(false)
      doc_builder_factory.setValidating(false)

      # Disable external entity processing
      doc_builder_factory.setFeature("http://apache.org/xml/features/nonvalidating/load-external-dtd", false)
      doc_builder_factory.setFeature("http://xml.org/sax/features/external-general-entities", false)
      doc_builder_factory.setFeature("http://xml.org/sax/features/external-parameter-entities", false)

      # Create document builder and parse HTML
      doc_builder = doc_builder_factory.newDocumentBuilder
      input_source = InputSource.new(StringReader.new(html_content))
      document = doc_builder.parse(input_source)

      # Create ITextRenderer instance (from openpdf-html / Flying Saucer)
      renderer = ITextRenderer.new

      # Set the parsed document
      renderer.setDocument(document, nil)

      # Layout the document
      renderer.layout

      # Create the PDF
      renderer.createPDF(output_stream)

      # Convert Java byte array to Ruby string
      java_bytes = output_stream.toByteArray
      ruby_bytes = String.from_java_bytes(java_bytes)

      ruby_bytes
    rescue => e
      raise e
    end
  end
end
