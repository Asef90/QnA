module LinksHelper

  def gist_content(link)
    gist_content = GistParseService.new(link).call
  end
end
