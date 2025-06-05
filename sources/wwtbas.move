
module wwtbas::wwtbas{

    use std::object;

    public struct Quiz has key, store{
        id:UID,
    }

    public fun get_id(quiz:Quiz) :UID{
        quiz.id;
    }

    public fun new_quiz(): Quiz {
        let quiz:Quiz = Quiz {
            id: object::new(ctx:ctx),
        };
        quiz
    }
}
