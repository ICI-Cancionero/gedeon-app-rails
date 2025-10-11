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

  def self.generate_playlist_pdf(playlist)
    new.generate_playlist_pdf(playlist)
  end

  def generate_playlist_pdf(playlist)
    # Ensure headless mode for Java AWT
    Java::JavaLang::System.setProperty('java.awt.headless', 'true')

    # Create HTML content from the playlist
    html_content = generate_html(playlist)

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

  private

  def generate_html(playlist)
    # HTMLWorker has very limited CSS support, so we use simple HTML without style tags
    html = ""

    # Title - using font tag with left alignment
    html += "<p align=\"left\"><font size=\"6\"><b>#{escape_html(playlist.name.titleize)}</b></font></p>\n"
    html += "<br/><br/>\n"

    playlist.playlist_sections.each do |section|
      # Section title
      html += "<p align=\"left\"><font size=\"5\"><b>#{escape_html(section.name.titleize)}</b></font></p>\n"
      html += "<br/>\n"

      section.playlist_items.each do |item|
        next unless item.song

        # Song title
        html += "<p align=\"left\"><font size=\"4\"><b>#{escape_html("#{item.position}. #{item.song.title.titleize}")}</b></font></p>\n"

        if item.song.content.present?
          # Song content - split by newlines and create left-aligned paragraphs
          item.song.content.split(/\n+/).each do |para|
            next if para.strip.empty?
            html += "<p align=\"left\">#{escape_html(para)}</p>\n"
          end
        end

        html += "<br/>\n"
      end

      html += "<br/>\n"
    end

    html
  end

  def escape_html(text)
    text.to_s
      .gsub('&', '&amp;')
      .gsub('<', '&lt;')
      .gsub('>', '&gt;')
      .gsub('"', '&quot;')
      .gsub("'", '&#39;')
  end
end
