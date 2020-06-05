class GistParseService

  def initialize(link, client: nil)
    @client = client || Octokit::Client.new
    @link_url = link.url
  end

  def call
    gist = @client.gist(gist_id)
    parse(gist)
  rescue Octokit::NotFound
    nil
  end

  private
  def gist_id
    @link_url.split('/').last
  end

  def parse(gist)
    result = ""
    gist.files.each { |name, file| result += "File name: #{name}\n\n#{file[:content]}\n\n" }
    result
  end
end
