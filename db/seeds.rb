# Load the latest wine database
puts "Importing L-WIN wine database. This may take a while"
importer = Importers::Lwin::Importer.new(Rails.root.join('db', 'L-Win_database.xls'))
importer.import
puts "Finished. Imported #{LwinIdentifier.count} identifiers and #{Wine.count} wines."
