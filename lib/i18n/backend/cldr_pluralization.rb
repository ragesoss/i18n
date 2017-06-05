# http://www.unicode.org/cldr/charts/latest/supplemental/language_plural_rules.html
#
# To enable locale specific pluralizations you can simply include the
# Pluralization module to the Simple backend - or whatever other backend you
# are using.
#
#   I18n::Backend::Simple.include(I18n::Backend::CldrPluralization)
#
# You also need to make sure to provide pluralization algorithms to the
# backend, i.e. include them to your I18n.load_path accordingly.

require 'i18n/cldr/plural_rules'

module I18n
  module Backend
    module CldrPluralization
      # Overwrites the Base backend translate method so that it will use
      # the CLDR plural rules.
      def pluralize(locale, entry, count)
        return entry unless entry.is_a?(Hash) and count
        locale_rules = CLDR_LANGUAGE_PLURAL_RULES[locale]
        return entry unless locale_rules
        key = locale_rules[:i18n][:plural][:rule].call(count)
        return super unless entry.has_key?(key)
        entry[key]
      end
    end
  end
end
