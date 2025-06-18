#[test_only]
module wwtbas::wwtbas_tests{

    use wwtbas::wwtbas;
    use sui::test_scenerio;


    const ENotImplemented: u64 = 0;

    #[test]
    fun test_can_create_quiz() {
        let sender :address = @0x123;
        let scenerio = test_scenerio_test::begin(sender);
        let ctx = scenerio.ctx();
        wwtbas::new_quiz(ctx);
        let effects = test_scenerio::end(scenerio);
        assert!(effects.);
        test_scenerio::end(scenerio);
    }
    
    #[test]
    fun test_can_add_question_to_quiz(){
        let sender :address = @0x123;
        let mut scenerio = test_scenerio_test::begin(sender);
        let ctx = scenerio.ctx();
        let quiz :Quiaz = wwtbas::Quiz{
            id: object::new(ctx),
        };
        let question = string::utf8(b"What is the capital of Malawi?");
        quiz.add_question(question);
        assert!(quiz.get_question)
    }


    #[test, expected_failure(abort_code = ::wwtbas::wwtbas_tests::ENotImplemented)]
    fun test_wwtbas_fail() {
        abort ENotImplemented
    }
}

