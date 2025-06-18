
module wwtbas::wwtbas{

    use sui::debug;
    use sui::
    public struct Quiz has key, store{
        id:UID,
    }

    public fun get_id(quiz:Quiz) :UID{
        quiz.id;
    }

    public fun new_quiz(ctx: @mut TxContent): Quiz {
        let quiz:Quiz = Quiz {
            id: object::new(ctx),
            questions: 
        };
        transfer::public_transfer(quiz, ctx.sender);
    }
}
