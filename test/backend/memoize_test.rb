# encoding: utf-8
$:.unshift(File.expand_path(File.dirname(__FILE__) + '/../')); $:.uniq!
require 'test_helper'
require 'backend/simple_test'

class I18nBackendMemoizeTest < I18nBackendSimpleTest
  module MemoizeSpy
    attr_accessor :spy_calls
    def available_locales
      self.spy_calls = (self.spy_calls||0) + 1
      super
    end
  end

  class MemoizeBackend < I18n::Backend::Simple
    include MemoizeSpy
    include I18n::Backend::Memoize
  end

  def setup
    I18n.backend = MemoizeBackend.new
    super
  end

  def test_memoizes_available_locales
    I18n.backend.spy_calls = 0
    assert I18n.available_locales, I18n.available_locales
    assert_equal 1, I18n.backend.spy_calls
  end

  def test_resets_available_locales_on_reload!
    I18n.available_locales
    I18n.backend.spy_calls = 0
    I18n.reload!
    assert I18n.available_locales, I18n.available_locales
    assert_equal 1, I18n.backend.spy_calls
  end

  def test_resets_available_locales_on_store_translations
    I18n.available_locales
    I18n.backend.spy_calls = 0
    I18n.backend.store_translations(:copa, :ca => :bana)
    assert I18n.available_locales, I18n.available_locales
    assert I18n.available_locales.include?(:copa)
    assert_equal 1, I18n.backend.spy_calls
  end
end