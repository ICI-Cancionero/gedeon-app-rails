require 'java'

class Pdf::IronPdfService
  include_package 'java.lang'
  include_package 'java.io'

  def self.generate_pdf_from_html(html_content, output_path = nil)
    begin
      # This is a proof of concept implementation
      # In a real implementation, you would:
      # 1. Add IronPDF JAR to the classpath
      # 2. Import the actual IronPDF classes
      # 3. Use IronPDF's API to convert HTML to PDF
      
      # For now, we'll create a simple demonstration
      output_path ||= Rails.root.join('tmp', "playlist_#{Time.current.to_i}.pdf")
      
      # Simulate PDF generation with a placeholder
      # In reality, this would use IronPDF's ChromePdfRenderer or similar
      pdf_content = generate_mock_pdf_content(html_content)
      
      File.write(output_path, pdf_content, mode: 'wb')
      
      {
        success: true,
        file_path: output_path,
        message: "PDF generated successfully using IronPDF (proof of concept)"
      }
    rescue => e
      {
        success: false,
        error: e.message,
        message: "Failed to generate PDF with IronPDF"
      }
    end
  end

  def self.generate_playlist_pdf(playlist)
    html_content = render_playlist_html(playlist)
    generate_pdf_from_html(html_content)
  end

  private

  def self.render_playlist_html(playlist)
    # Generate HTML content for the playlist
    html = <<~HTML
      <!DOCTYPE html>
      <html>
      <head>
        <title>#{playlist.name}</title>
        <style>
          body { font-family: Arial, sans-serif; margin: 20px; }
          h1 { color: #333; border-bottom: 2px solid #ccc; }
          .section { margin-bottom: 20px; }
          .song { margin: 10px 0; padding: 5px; background: #f9f9f9; }
          .scripture { margin: 10px 0; padding: 10px; background: #e8f4f8; }
        </style>
      </head>
      <body>
        <h1>#{playlist.name}</h1>
        <p>Generated on: #{Time.current.strftime('%B %d, %Y at %I:%M %p')}</p>
        <p>Status: #{playlist.active? ? 'Active' : 'Inactive'}</p>
        
        <div class="content">
          #{render_playlist_sections(playlist)}
        </div>
        
        <footer>
          <p><em>Proof of Concept</em></p>
        </footer>
      </body>
      </html>
    HTML
    
    html
  end

  def self.render_playlist_sections(playlist)
    return "<p>No sections available</p>" unless playlist.playlist_sections.any?
    
    sections_html = playlist.playlist_sections.map do |section|
      <<~SECTION
        <div class="section">
          <h2>#{section.name}</h2>
          #{render_section_items(section)}
        </div>
      SECTION
    end
    
    sections_html.join("\n")
  end

  def self.render_section_items(section)
    items_html = []
    
    # Render songs
    if section.playlist_items.any?
      items_html << "<h3>Songs:</h3>"
      section.playlist_items.includes(:song).each do |item|
        next unless item.song
        items_html << <<~SONG
          <div class="song">
            <h4>#{item.position}. #{item.song.title}</h4>
            #{item.song.author ? "<p>by #{item.song.author}</p>" : ''}
            <div class="song-content">
              #{item.song.content ? item.song.content.gsub(/\n/, '<br>') : ''}
            </div>
          </div>
        SONG
      end
    end
    
    # Render scriptures
    if section.scriptures.any?
      items_html << "<h3>Scriptures:</h3>"
      section.scriptures.each do |scripture|
        items_html << <<~SCRIPTURE
          <div class="scripture">
            <strong>#{scripture.bible_version} - #{scripture.book_id || 'Unknown'} #{scripture.chapter_num}:#{scripture.from}-#{scripture.to}</strong>
            <p>#{scripture.content}</p>
          </div>
        SCRIPTURE
      end
    end
    
    items_html.join("\n")
  end

  def self.generate_mock_pdf_content(html_content)
    # This creates a simple PDF with actual content for demonstration
    # In a real implementation, IronPDF would convert the HTML to actual PDF bytes
    
    # Remove CSS, script, and title content first
    clean_html = html_content.gsub(/<style[^>]*>.*?<\/style>/m, '')
                             .gsub(/<script[^>]*>.*?<\/script>/m, '')
                             .gsub(/<title[^>]*>.*?<\/title>/m, '')
                             .gsub(/<head[^>]*>.*?<\/head>/m, '')
    
    # Extract text content from HTML for the PDF with better formatting
    text_content = clean_html.gsub(/<br\s*\/?>/i, "\n")      # Convert <br> to newlines
                             .gsub(/<\/p>/i, "\n\n")         # Convert </p> to double newlines
                             .gsub(/<\/h[1-6]>/i, "\n\n")    # Convert heading endings to double newlines
                             .gsub(/<\/div>/i, "\n")         # Convert div endings to newlines
                             .gsub(/<h[1-6][^>]*>/i, "\n")   # Add newline before headings
                             .gsub(/<div[^>]*class="song"[^>]*>/i, "\n\n") # Add spacing before songs
                             .gsub(/<div[^>]*class="scripture"[^>]*>/i, "\n\n") # Add spacing before scriptures
                             # Preserve bold formatting for titles and headings - do this FIRST
                             .gsub(/<h1[^>]*>(.*?)<\/h1>/mi, "\n\n=== \1 ===\n")      # Main title
                             .gsub(/<h2[^>]*>(.*?)<\/h2>/mi, "\n\n--- \1 ---\n")      # Section titles  
                             .gsub(/<h3[^>]*>(.*?)<\/h3>/mi, "\n\n*** \1 ***\n")      # Subsection (Songs/Scriptures)
                             .gsub(/<h4[^>]*>(.*?)<\/h4>/mi, "\n*** \1 ***\n")        # Song titles
                             .gsub(/<strong[^>]*>(.*?)<\/strong>/mi, '*** \1 ***')    # Strong text
                             .gsub(/<b[^>]*>(.*?)<\/b>/mi, '*** \1 ***')              # Bold text
                             .gsub(/<[^>]*>/, '')             # Remove remaining HTML tags
                             .gsub(/\n\s*\n\s*\n+/, "\n\n")  # Normalize multiple newlines to double
                             .gsub(/[ \t]+/, ' ')             # Normalize spaces and tabs
                             .gsub(/[ \t]*\n/, "\n")         # Clean up spaces before newlines
                             .strip
                             # Fix common encoding issues for Spanish characters
                             .gsub(/á|Ã¡|â/, 'a')
                             .gsub(/é|Ã©|ê/, 'e')
                             .gsub(/í|Ã­|î/, 'i')
                             .gsub(/ó|Ã³|ô/, 'o')
                             .gsub(/ú|Ãº|û/, 'u')
                             .gsub(/ñ|Ã±/, 'n')
                             .gsub(/Á|Ã/, 'A')
                             .gsub(/É|Ã‰/, 'E')
                             .gsub(/Í|Ã/, 'I')
                             .gsub(/Ó|Ã"/, 'O')
                             .gsub(/Ú|Ãš/, 'U')
                             .gsub(/Ñ|Ã'/, 'N')
    
    # Create a basic PDF with the playlist content
    content_stream = "BT /F1 12 Tf 72 720 Td"
    
    # Split content into lines that fit on the page, respecting existing line breaks
    lines = []
    paragraphs = text_content.split(/\n+/)
    
    paragraphs.each do |paragraph|
      if paragraph.strip.empty?
        lines << ""  # Add blank line for spacing
        next
      end
      
      current_line = ""
      words = paragraph.split(' ')
      
      words.each do |word|
        if (current_line + " " + word).length < 80
          current_line += (current_line.empty? ? "" : " ") + word
        else
          lines << current_line unless current_line.empty?
          current_line = word
        end
      end
      lines << current_line unless current_line.empty?
      lines << ""  # Add spacing between paragraphs
    end
    
    # Add each line to the PDF with proper spacing
    lines.first(50).each_with_index do |line, index|
      if line.strip.empty?
        content_stream += " 0 -15 Td"  # Just move down for empty lines
      else
        escaped_line = line.gsub(/[()\\]/, '').strip
        content_stream += " (#{escaped_line}) Tj 0 -15 Td"
      end
    end
    
    content_stream += " ET"
    content_length = content_stream.length
    
    mock_pdf = <<~PDF
      %PDF-1.4
      1 0 obj
      <<
      /Type /Catalog
      /Pages 2 0 R
      >>
      endobj
      
      2 0 obj
      <<
      /Type /Pages
      /Kids [3 0 R]
      /Count 1
      >>
      endobj
      
      3 0 obj
      <<
      /Type /Page
      /Parent 2 0 R
      /MediaBox [0 0 612 792]
      /Contents 4 0 R
      /Resources <<
        /Font <<
          /F1 <<
            /Type /Font
            /Subtype /Type1
            /BaseFont /Helvetica
          >>
        >>
      >>
      >>
      endobj
      
      4 0 obj
      <<
      /Length #{content_length}
      >>
      stream
      #{content_stream}
      endstream
      endobj
      
      xref
      0 5
      0000000000 65535 f 
      0000000009 00000 n 
      0000000058 00000 n 
      0000000115 00000 n 
      0000000289 00000 n 
      trailer
      <<
      /Size 5
      /Root 1 0 R
      >>
      startxref
      #{350 + content_length}
      %%EOF
    PDF
    
    mock_pdf
  end
end