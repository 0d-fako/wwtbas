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
        let quiz = wwtbas::new_quiz(ctx);
        assert!(test_scenerio.num_concluded_txes()!=0);
        test_scenerio::end(scenerio);
    }

    #[test, expected_failure(abort_code = ::wwtbas::wwtbas_tests::ENotImplemented)]
    fun test_wwtbas_fail() {
        abort ENotImplemented
    }
}

