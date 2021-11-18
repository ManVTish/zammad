# Copyright (C) 2012-2021 Zammad Foundation, http://zammad-foundation.org/

class Generators::TranslationCatalog::Extractor::Base

  attr_accessor :strings, :references

  def initialize
    @strings = Set[]
    @references = {}
  end

  def extract_translatable_strings(base_path)
    find_files(base_path).each do |file|
      extract_from_string(File.read(file), file.remove("#{base_path}/"))
    end
  end

  def extract_from_string(string, filename)
    raise NotImplementedError
  end

  def find_files(base_path)
    raise NotImplementedError
  end
end