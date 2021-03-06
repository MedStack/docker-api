# This class represents a Docker Node. It's important to note that nothing
# is cached so that the information is always up to date.
class Docker::Node
  include Docker::Base

  def self.all(opts = {}, conn = Docker.connection)
    hashes = Docker::Util.parse_json(conn.get('/nodes', opts)) || []
    hashes.map { |hash| new(conn, hash) }
  end

  def self.get(id, conn = Docker.connection)
    node_json = conn.get("/nodes/#{Docker::Util.escape(id)}")
    new(conn, Docker::Util.parse_json(node_json) || {})
  end

  def self.remove(id, conn = Docker.connection)
    json = conn.delete("/nodes/#{Docker::Util.escape(id)}")
    Docker::Util.parse_json(json) || {}
  end

  def remove(opts = {})
    connection.delete("/nodes/#{self.id}", opts)
    nil
  end

  def update(opts)
    options = {
      version: info.dig("Version", "Index")
    }

    connection.post("/nodes/#{self.id}/update", options, body: opts.to_json)
  end

  private_class_method :new
end
