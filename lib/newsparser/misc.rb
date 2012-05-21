class Object
  def tap(value)
    yield(value)
    value
  end unless defined?(tap)
end
