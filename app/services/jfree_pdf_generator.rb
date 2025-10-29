require 'tempfile'

class JfreePdfGenerator
  # Set headless mode before any Java AWT imports
  Java::JavaLang::System.setProperty('java.awt.headless', 'true') if defined?(Java)

  java_import 'org.jfree.pdf.PDFDocument'
  java_import 'org.jfree.pdf.PDFGraphics2D'
  java_import 'org.jfree.pdf.Page'
  java_import 'java.awt.Font'
  java_import 'java.awt.Color'
  java_import 'java.awt.geom.Rectangle2D'
  java_import 'java.awt.RenderingHints'
  java_import 'java.awt.GraphicsEnvironment'

  def self.generate_playlist_pdf(playlist)
    new.generate_playlist_pdf(playlist)
  end

  def generate_playlist_pdf(playlist)
    # Ensure headless mode for Java AWT
    Java::JavaLang::System.setProperty('java.awt.headless', 'true')

    # Create a new PDF document
    pdf_document = PDFDocument.new

    begin
      # Add title page
      add_title_page(pdf_document, playlist)

      # Add content pages for each section
      playlist.playlist_sections.each do |section|
        add_section_page(pdf_document, section)
      end

      # Create a temporary file to write the PDF
      temp_file = Tempfile.new(['playlist', '.pdf'])
      temp_file.close

      # Create a Java File object from the path
      java_file = Java::JavaIo::File.new(temp_file.path)

      # Write the document to the temporary file
      pdf_document.write_to_file(java_file)

      # Read the file content as bytes using Ruby File class
      ::File.binread(temp_file.path)
    ensure
      # Clean up resources
      temp_file&.unlink
    end
  end

  private

  def add_title_page(pdf_document, playlist)
    page = pdf_document.createPage(Rectangle2D::Double.new(0, 0, 595, 842)) # A4 size
    graphics = page.getGraphics2D

    # Set rendering hints for better text quality
    graphics.setRenderingHint(RenderingHints::KEY_TEXT_ANTIALIASING, RenderingHints::VALUE_TEXT_ANTIALIAS_ON)
    graphics.setRenderingHint(RenderingHints::KEY_FRACTIONALMETRICS, RenderingHints::VALUE_FRACTIONALMETRICS_ON)

    # Set title font
    title_font = Font.new("SansSerif", Font::BOLD, 24)
    graphics.setFont(title_font)
    graphics.setColor(Color::BLACK)

    # Calculate title position (centered)
    page_width = 595
    title_text = playlist.name.titleize
    font_metrics = graphics.getFontMetrics(title_font)
    title_width = font_metrics.stringWidth(title_text)
    title_x = (page_width - title_width) / 2
    title_y = 100

    # Draw title
    graphics.drawString(ensure_utf8(title_text), title_x, title_y)

    # Add subtitle
    subtitle_font = Font.new("SansSerif", Font::PLAIN, 16)
    graphics.setFont(subtitle_font)
    subtitle_text = "Generated with JFree PDF"
    subtitle_metrics = graphics.getFontMetrics(subtitle_font)
    subtitle_width = subtitle_metrics.stringWidth(subtitle_text)
    subtitle_x = (page_width - subtitle_width) / 2
    subtitle_y = title_y + 40

    graphics.drawString(ensure_utf8(subtitle_text), subtitle_x, subtitle_y)

    # Add creation date
    date_text = "Created: #{Time.current.strftime('%B %d, %Y')}"
    date_metrics = graphics.getFontMetrics(subtitle_font)
    date_width = date_metrics.stringWidth(date_text)
    date_x = (page_width - date_width) / 2
    date_y = subtitle_y + 30

    graphics.drawString(ensure_utf8(date_text), date_x, date_y)

    graphics.dispose
  end

  def add_section_page(pdf_document, section)
    page = pdf_document.createPage(Rectangle2D::Double.new(0, 0, 595, 842)) # A4 size
    graphics = page.getGraphics2D

    # Set rendering hints for better text quality
    graphics.setRenderingHint(RenderingHints::KEY_TEXT_ANTIALIASING, RenderingHints::VALUE_TEXT_ANTIALIAS_ON)
    graphics.setRenderingHint(RenderingHints::KEY_FRACTIONALMETRICS, RenderingHints::VALUE_FRACTIONALMETRICS_ON)

    page_width = 595
    page_height = 842
    margin = 50
    current_y = margin + 50

    # Section title
    section_font = Font.new("SansSerif", Font::BOLD, 20)
    graphics.setFont(section_font)
    graphics.setColor(Color::BLACK)

    section_title = section.name.present? ? section.name.titleize : "Section"
    section_metrics = graphics.getFontMetrics(section_font)
    section_width = section_metrics.stringWidth(section_title)
    section_x = (page_width - section_width) / 2

    graphics.drawString(ensure_utf8(section_title), section_x, current_y)
    current_y += 50

    # Song content
    song_font = Font.new("SansSerif", Font::PLAIN, 12)
    title_font = Font.new("SansSerif", Font::BOLD, 14)

    section.playlist_items.each do |item|
      next unless item.song

      # Check if we need a new page
      if current_y > page_height - 200
        graphics.dispose
        page = pdf_document.createPage(Rectangle2D::Double.new(0, 0, 595, 842))
        graphics = page.getGraphics2D
        # Set rendering hints for new page
        graphics.setRenderingHint(RenderingHints::KEY_TEXT_ANTIALIASING, RenderingHints::VALUE_TEXT_ANTIALIAS_ON)
        graphics.setRenderingHint(RenderingHints::KEY_FRACTIONALMETRICS, RenderingHints::VALUE_FRACTIONALMETRICS_ON)
        graphics.setFont(song_font) # Reset font for new page
        current_y = margin + 50
      end

      # Song title
      graphics.setFont(title_font)
      song_title = "#{item.position}. #{item.song.title.titleize}"
      graphics.drawString(ensure_utf8(song_title), margin, current_y)
      current_y += 25

      # Song content
      graphics.setFont(song_font)
      if item.song.content.present?
        content_lines = wrap_text(item.song.content, page_width - (2 * margin), graphics.getFontMetrics(song_font))
        content_lines.each do |line|
          graphics.drawString(ensure_utf8(line), margin, current_y)
          current_y += 15
        end
      end

      current_y += 20 # Space between songs
    end

    graphics.dispose
  end

  def wrap_text(text, max_width, font_metrics)
    words = text.split(/\s+/)
    lines = []
    current_line = ""

    words.each do |word|
      test_line = current_line.empty? ? word : "#{current_line} #{word}"
      if font_metrics.stringWidth(test_line) <= max_width
        current_line = test_line
      else
        lines << current_line unless current_line.empty?
        current_line = word
      end
    end

    lines << current_line unless current_line.empty?
    lines
  end

  def ensure_utf8(text)
    # Convert to string and handle all character encoding issues universally
    string_text = text.to_s
    
    # Replace accented characters with their base equivalents since the font doesn't support them well
    # This uses Unicode normalization and character replacement
    string_text.tr(
      'ÀÁÂÃÄÅàáâãäåÈÉÊËèéêëÌÍÎÏìíîïÒÓÔÕÖØòóôõöøÙÚÛÜùúûüÑñÇç',
      'AAAAAAaaaaaaEEEEeeeeIIIIiiiiOOOOOOooooooUUUUuuuuNnCc'
    )
  end
end