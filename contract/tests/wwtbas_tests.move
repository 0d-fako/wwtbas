#[test_only]
module wwtbas::wwtbas_tests;

use std::string;
use sui::object;
use sui::test_scenario;
use wwtbas::wwtbas;

const ENotImplemented: u64 = 0;

#[test]
fun test_can_create_quiz() {
    let sender: address = @0x123;
    let mut scenario = test_scenario::begin(sender);
    {
        let ctx = test_scenario::ctx(&mut scenario);
        wwtbas::new_quiz(ctx);
    };
    let effects = test_scenario::end(scenario);
 
}

#[test]
fun test_can_add_question_to_quiz() {
    let sender: address = @0x123;
    let mut scenario = test_scenario::begin(sender);
    {
        let ctx = test_scenario::ctx(&mut scenario);
        wwtbas::new_quiz(ctx);
    };
    test_scenario::next_tx(&mut scenario, sender);
    {
        let ctx = test_scenario::ctx(&mut scenario);
        let mut quiz = test_scenario::take_from_sender<wwtbas::Quiz>(&scenario);
        let question = string::utf8(b"What is the capital of Malawi?");

        wwtbas::add_question(&mut quiz, question);

        test_scenario::return_to_sender(&scenario, quiz);
    };
    test_scenario::end(scenario);
}

#[test, expected_failure(abort_code = ::wwtbas::wwtbas_tests::ENotImplemented)]
fun test_wwtbas_fail() {
    abort ENotImplemented
}

