class Docker::Config
  include Docker::Base

  def self.all(opts = {}, conn = Docker.connection)
    hashes = Docker::Util.parse_json(conn.get("/configs", opts))
    Array(hashes).map { |hash| new(conn, hash) }
  end

  def self.get(id, opts = {}, conn = Docker.connection)
    resp = conn.get("/configs/#{URI.encode(id)}", opts)
    hash = Docker::Util.parse_json(resp) || {}
    new(conn, hash)
  end

  def self.create(opts = {}, conn = Docker.connection)
    resp = conn.post("/configs/create", {}, body: opts.to_json)
    hash = Docker::Util.parse_json(resp) || {}
    new(conn, hash)
  end

  def update(opts = {})
    options = {
      version: info.dig("Version", "Index")
    }

    connection.post("/configs/#{id}/update", options, body: opts.to_json)
    true
  end

  def remove(options = {})
    connection.delete("/configs/#{id}", options)
    true
  end
  alias_method :delete, :remove
end
