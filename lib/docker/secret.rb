# This class represents a Docker Secret. Secrets are part of the Swarm API.
class Docker::Secret
  include Docker::Base

  def self.all(opts = {}, conn = Docker.connection)
    hashes = Docker::Util.parse_json(conn.get("/secrets", opts))
    Array(hashes).map { |hash| new(conn, hash) }
  end

  def self.get(id, opts = {}, conn = Docker.connection)
    resp = conn.get("/secrets/#{URI.encode(id)}", opts)
    hash = Docker::Util.parse_json(resp) || {}
    new(conn, hash)
  end

  def self.create(opts = {}, conn = Docker.connection)
    resp = conn.post("/secrets/create", {}, body: opts.to_json)
    hash = Docker::Util.parse_json(resp) || {}
    new(conn, hash)
  end

  def remove(options = {})
    connection.delete("/secrets/#{id}", options)
    true
  end
  alias_method :delete, :remove
end
