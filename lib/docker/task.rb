# This class represents a Docker Swarm Task.
class Docker::Task
  include Docker::Base

  def self.all(opts = {}, conn = Docker.connection)
    hashes = Docker::Util.parse_json(conn.get("/tasks", opts))
    Array(hashes).map { |hash| new(conn, hash) }
  end

  def self.get(id, conn = Docker.connection)
    resp = conn.get("/tasks/#{id}")
    new(conn, Docker::Util.parse_json(resp) || {})
  end
end
