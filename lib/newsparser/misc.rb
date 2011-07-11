class Object
  def returning(value)
    yield(value)
    value
  end unless defined?(returning)
end
