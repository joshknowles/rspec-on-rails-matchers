module Spec
  module Rails
    module Matchers
      def validate_presence_of(attribute)
        return simple_matcher("model to validate the presence of #{attribute}") do |model|
          model[attribute] = nil
          !model.valid? && model.errors.invalid?(attribute)
        end
      end

      def validate_length_of(attribute, options)
        min = options[:between].first
        max = options[:between].last

        return simple_matcher("model to validate the length of #{attribute} between #{min} and #{max}") do |model|
          model[attribute] = 'a' * (min - 1)

          invalid = !model.valid? && model.errors.invalid?(attribute)

          model[attribute] = 'a' * (max + 1)

          invalid && !model.valid? && model.errors.invalid?(attribute)
        end
      end

      def validate_uniqueness_of(attribute)
        return simple_matcher("model to validate the uniqueness of #{attribute}") do |model|
          model.class.stub!(:find).and_return(true)
          !model.valid? && model.errors.invalid?(attribute)
        end
      end

      def validate_confirmation_of(attribute)
        return simple_matcher("model to validate the confirmation of #{attribute}") do |model|
          model.send("#{attribute}_confirmation=", 'asdf')
          !model.valid? && model.errors.invalid?(attribute)
        end
      end
    end
  end
end