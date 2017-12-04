def alias_template(destination_path)
<<-EOF
<html><head> <meta http-equiv="refresh" content="0; url=#{destination_path}" /></head> </html>
EOF
end

module Jekyll
  class PagelessRedirectFile < Page
    def write(dest)
      return true
    end
  end
end

Jekyll::Hooks.register :posts, :pre_render do |post|
  require 'translit'
  site = post.site
  url = URI.decode(post.url)
  path = Translit.convert(url, :english)
  if path != url
    post.data['redirect'] = path
    path = File.join(site.dest, path)
    FileUtils.mkdir_p(path)
    File.open(File.join(path, "index.html"), 'w') do |file|
      file.write(alias_template(url))
      site.pages << Jekyll::PagelessRedirectFile.new(site, site.dest, path, "index.html")
    end
  end
end