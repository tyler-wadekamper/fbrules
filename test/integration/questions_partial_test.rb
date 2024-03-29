require "test_helper"

# These tests are designed to verify the HTML contents of requests and their responses for each view.
# Any functionality that relies on javascript or requires UI interaction should be tested in system/feature_tests

class QuestionsPartialTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  class UnauthenticatedTest < QuestionsPartialTest
    setup do
      @user = create_default_user
      sign_in @user

      post questions_url, params: VALID_QUESTION_PARAMS
      sign_out @user

      get questions_url(Question.first.id)
    end

    test "shows the first and last name of author" do
      author = Question.first.author
      assert_select "turbo-frame.question" do
        assert_select "div.author-name", "#{author.first_name} #{author.last_name}"
      end
    end
  
    test "shows the time elapsed since the question was posted" do
      assert_select "turbo-frame.question" do
        assert_select "div.time-elapsed", "Posted less than a minute ago"
      end
    end

    test "shows the time elapsed since the question was edited" do
      sign_in @user
      patch question_url(Question.first.id), params: VALID_UPDATE_PARAMS
      get questions_url(Question.first.id)
      
      assert_select "turbo-frame.question" do
        assert_select "div.time-elapsed", "Edited less than a minute ago"
      end
    end

    test "shows the question body" do
      assert_select "turbo-frame.question" do
        assert_select "div.body", "#{Question.first.body}"
      end
    end

    test "shows the show answer button" do
      assert_select "turbo-frame.question" do
        assert_select "button.answer-button", "Show Answer"
      end
    end

    test "the answer content is present" do
      assert_select "turbo-frame.question" do
        assert_select "div.answer", "#{Question.first.answer.text}"
        assert_select "div.explanation", "#{Question.first.answer.explanation}"
      end
    end

    test "does not show the edit button" do
      assert_select "turbo-frame.question" do
        assert_select "a", { count: 0, text: "Edit" }
      end
    end

    test "does not show the delete button" do
      assert_select "turbo-frame.question" do
        assert_select "a", { count: 0, text: "Delete" }
      end
    end
  end

  class AuthenticatedTest < QuestionsPartialTest
    setup do
      @user = create_default_user
      sign_in @user
      post questions_url, params: VALID_QUESTION_PARAMS

      get questions_url(Question.first.id)
    end

    test "shows the edit button" do
      assert_select "turbo-frame.question" do
        assert_select "a", { count: 1, text: "Edit" }
      end
    end

    test "shows the delete button" do
      assert_select "turbo-frame.question" do
        assert_select "a", { count: 1, text: "Delete" }
      end
    end
  end

  class AuthenticatedSecondUserTest < QuestionsPartialTest
    setup do
      user = create_default_user
      sign_in user
      post questions_url, params: VALID_QUESTION_PARAMS
      sign_out user

      user2 = create_random_user
      sign_in user2

      get questions_url(Question.first.id)
    end

    test "does not show the edit button" do
      assert_select "turbo-frame.question" do
        assert_select "a", { count: 0, text: "Edit" }
      end
    end

    test "does not show the delete button" do
      assert_select "turbo-frame.question" do
        assert_select "a", { count: 0, text: "Delete" }
      end
    end
  end

  class ReferenceTest < QuestionsPartialTest
    setup do
      user = create_default_user
      answer = build(:answer)

      create_sample_references('6')
      @references = Reference.first(5)

      create(:question, author: user, answer:, reference_ids: @references.map(&:id))

      get questions_url(Question.first.id)
    end

    test "shows the rule references with links" do
      @references.each do |reference|
        assert_select "div.references-container" do
          assert_select 'a', /.*#{reference.name}/ if reference.name
          assert_select 'span', reference.text
          assert_select 'a[href=?]', "/references/#{reference.id}"
        end
      end
    end
  end
end