# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# FHIR schema models
# (YAML obtained from https://hapi.fhir.org/baseR4/api-docs)
paths = Psych.load_file('hapi_schema.yml')['paths'].reject do |path, _v|
  path.end_with?('/{id}') ||
  path.include?('/$') || # meta, expunge, diff, graphql, validate, validate-code, invalidate-expansion, meta-delete, snapshot, export, translate, upload-external-code-system, apply-codesystem-delta-add, apply-codesystem-delta-remove
  path.end_with?('/_history') ||
  path.end_with?('/_search') ||
  path.end_with?('/{version_id}') ||
  ['/', '/metadata'].include?(path)
end

paths.each do |path, v|
  # paths['/Observation']['get']['parameters'].map{|x| x['name']}
  binding.pry if (tag = v['get']['tags']).length > 1
  tag = tag.first
  outp = +"class Create#{tag} < ActiveRecord::Migration[7.0]
  def change
    create_table :#{tag.underscore.pluralize} do |t|
"

  v['get']['parameters'].each do |param|
    # next if [].include?(descrip = param['description'])
    outp << "      t.string :#{param['name'].tr('-', '_')} # #{descrip}\n"
  end
  outp << "    end
  end
end

"
  puts outp
  binding.pry
  x = 5
end
