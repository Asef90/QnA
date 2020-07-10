ThinkingSphinx::Index.define :comment, with: :active_record do
  #fields
  indexes body
  indexes author.email, as: :author, sortable: true

  #attributes
  has author_id, created_at, updated_at
end
