module wwtbas::wwtbas {
    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;
    use std::string::{Self, String};
    use std::vector;


    const EQuizNotFound: u64 = 0;
    const EInvalidQuestionIndex: u64 = 1;
    const EQuizAlreadyStarted: u64 = 2;

   
    public struct Question has store, copy, drop {
        question_text: String,
        option_a: String,
        option_b: String,
        option_c: String,
        option_d: String,
        correct_answer: u8,
        prize_value: u64,
    }


    public struct Quiz has key, store {
        id: UID,
        questions: vector<Question>,
        current_question: u64,
        is_active: bool,
        prize_pool: u64,
        creator: address,
    }

   
    public struct GameState has key {
        id: UID,
        quiz_id: address,
        player: address,
        current_question_index: u64,
        total_winnings: u64,
        is_finished: bool,
    }

    // === Quiz Management Functions ===

  
    public fun new_quiz(ctx: &mut TxContext): Quiz {
        let quiz = Quiz {
            id: object::new(ctx),
            questions: vector::empty<Question>(),
            current_question: 0,
            is_active: false,
            prize_pool: 0,
            creator: tx_context::sender(ctx),
        };
        quiz
    }

    
    public fun add_question(
        quiz: &mut Quiz,
        question_text: String,
        option_a: String,
        option_b: String,
        option_c: String,
        option_d: String,
        correct_answer: u8,
        prize_value: u64,
    ) {
        let question = Question {
            question_text,
            option_a,
            option_b,
            option_c,
            option_d,
            correct_answer,
            prize_value,
        };
        vector::push_back(&mut quiz.questions, question);
    }

   
    public fun start_quiz(quiz: &mut Quiz) {
        quiz.is_active = true;
    }

    
    public fun start_game(quiz: &Quiz, ctx: &mut TxContext) {
        assert!(quiz.is_active, EQuizAlreadyStarted);
        
        let game_state = GameState {
            id: object::new(ctx),
            quiz_id: object::uid_to_address(&quiz.id),
            player: tx_context::sender(ctx),
            current_question_index: 0,
            total_winnings: 0,
            is_finished: false,
        };
        
        transfer::transfer(game_state, tx_context::sender(ctx));
    }

    // === Getter Functions ===

  
    public fun get_id(quiz: &Quiz): &UID {
        &quiz.id
    }

    
    public fun get_question_count(quiz: &Quiz): u64 {
        vector::length(&quiz.questions)
    }

  
    public fun get_question(quiz: &Quiz, index: u64): &Question {
        assert!(index < vector::length(&quiz.questions), EInvalidQuestionIndex);
        vector::borrow(&quiz.questions, index)
    }

   
    public fun is_quiz_active(quiz: &Quiz): bool {
        quiz.is_active
    }

  
    public fun get_creator(quiz: &Quiz): address {
        quiz.creator
    }

   
    public fun get_current_question(quiz: &Quiz): u64 {
        quiz.current_question
    }

    // === Question Getter Functions ===

 
    public fun get_question_text(question: &Question): &String {
        &question.question_text
    }

    
    public fun get_option_a(question: &Question): &String {
        &question.option_a
    }

   
    public fun get_option_b(question: &Question): &String {
        &question.option_b
    }

  
    public fun get_option_c(question: &Question): &String {
        &question.option_c
    }

    public fun get_option_d(question: &Question): &String {
        &question.option_d
    }

   
    public fun get_correct_answer(question: &Question): u8 {
        question.correct_answer
    }

    
    public fun get_prize_value(question: &Question): u64 {
        question.prize_value
    }

    // === Game State Functions ===


    public fun answer_question(
        game_state: &mut GameState,
        quiz: &Quiz,
        answer: u8,
    ): bool {
        assert!(!game_state.is_finished, EQuizAlreadyStarted);
        assert!(game_state.current_question_index < vector::length(&quiz.questions), EInvalidQuestionIndex);
        
        let question = vector::borrow(&quiz.questions, game_state.current_question_index);
        let is_correct = question.correct_answer == answer;
        
        if (is_correct) {
            game_state.total_winnings = game_state.total_winnings + question.prize_value;
            game_state.current_question_index = game_state.current_question_index + 1;
            
           
            if (game_state.current_question_index >= vector::length(&quiz.questions)) {
                game_state.is_finished = true;
            };
        } else {
            game_state.is_finished = true;
        };
        
        is_correct
    }

    
    public fun get_game_player(game_state: &GameState): address {
        game_state.player
    }

  
    public fun get_total_winnings(game_state: &GameState): u64 {
        game_state.total_winnings
    }

    
    public fun is_game_finished(game_state: &GameState): bool {
        game_state.is_finished
    }

    
    public fun get_game_current_question(game_state: &GameState): u64 {
        game_state.current_question_index
    }

    // === Admin Functions ===


    public fun transfer_quiz(quiz: Quiz, recipient: address) {
        transfer::public_transfer(quiz, recipient);
    }

  
    public fun share_quiz(quiz: Quiz) {
        transfer::share_object(quiz);
    }

    // === Helper Functions ===

    public fun create_sample_question(): Question {
        Question {
            question_text: string::utf8(b"What is the capital of Malawi?"),
            option_a: string::utf8(b"Lilongwe"),
            option_b: string::utf8(b"Blantyre"),
            option_c: string::utf8(b"Mzuzu"),
            option_d: string::utf8(b"Zomba"),
            correct_answer: 0, 
            prize_value: 1000,
        }
    }
}