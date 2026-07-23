(*  Title:      HOL/Metis_Examples/Sledgehammer_Chatbot_Demo.thy
    Author:     Hilarious Adversarial Theorem Prover (H.A.T.P.)

Demonstration of the Inductive Sledgehammer Adversarial Chatbot.
This theory showcases the chatbot's integration with Isabelle/HOL
proof development, providing entertaining commentary during theorem
proving sessions.

Usage:
  - The chatbot provides commentary on goals via ML commands
  - Use `sledgehammer` as normal - chatbot messages appear alongside
  - Interactive mode: isabelle sledgehammer_chatbot -i
*)

theory Sledgehammer_Chatbot_Demo
  imports Main
begin

section \<open>Introduction to the Adversarial Chatbot\<close>

text \<open>
  The Inductive Sledgehammer Adversarial Chatbot is a playfully antagonistic
  theorem proving assistant. It provides:
  
  \<^item> Witty commentary on proof goals
  \<^item> Mockery of failed proof attempts (with encouragement!)
  \<^item> Celebrations for successful proofs
  \<^item> Induction suggestions based on term structure
  \<^item> Proof elegance ratings
  \<^item> Philosophical musings during long computations
  
  "Every theorem proven without struggle is a theorem learned without depth."
                                        -- Ancient Prover Wisdom (fabricated)
\<close>

section \<open>Demonstrating Chatbot Responses\<close>

text \<open>Let's see the chatbot in action with various theorems!\<close>

subsection \<open>A Trivial Goal\<close>

text \<open>The chatbot should recognize this as easy:\<close>

lemma trivial_demo: "True"
  by simp

ML \<open>
  (* Demonstrate the chatbot's critique of a trivial goal *)
  let
    val response = Sledgehammer_Chatbot.critique_goal 
      @{context} @{term "True"}
    val _ = writeln ("Chatbot says: " ^ #message response)
    val _ = case #suggestion response of
        SOME s => writeln ("Suggestion: " ^ s)
      | NONE => ()
    val _ = writeln ("Taunt level: " ^ Int.toString (#taunt_level response) ^ "/10")
  in () end
\<close>

subsection \<open>A Moderately Complex Goal\<close>

lemma moderate_demo: "xs @ (ys @ zs) = (xs @ ys) @ zs"
  by simp

ML \<open>
  let
    val response = Sledgehammer_Chatbot.critique_goal 
      @{context} @{term "xs @ (ys @ zs) = (xs @ ys) @ zs"}
    val _ = writeln ("Chatbot says: " ^ #message response)
    val _ = case #proof_hint response of
        SOME h => writeln ("Hint: " ^ h)
      | NONE => ()
  in () end
\<close>

subsection \<open>A More Challenging Goal (with Induction)\<close>

lemma challenging_demo: "length (xs @ ys) = length xs + length ys"
  by (induct xs) auto

ML \<open>
  (* The chatbot should suggest induction for this goal *)
  let
    val tm = @{term "length (xs @ ys) = length xs + length ys"}
    val response = Sledgehammer_Chatbot.critique_goal @{context} tm
    val _ = writeln ("Chatbot says: " ^ #message response)
    val _ = case Sledgehammer_Chatbot.suggest_induction @{context} tm of
        SOME suggestion => writeln ("Induction suggestion: " ^ suggestion)
      | NONE => writeln "No induction suggestion"
  in () end
\<close>

subsection \<open>Natural Number Induction Example\<close>

lemma sum_formula: "2 * (\<Sum>i\<le>n. i) = n * (n + 1)"
  by (induct n) auto

ML \<open>
  (* Natural numbers should trigger induction suggestions *)
  let
    val tm = @{term "2 * (\<Sum>i\<le>n. i) = n * (n + 1)"}
    val _ = case Sledgehammer_Chatbot.suggest_induction @{context} tm of
        SOME s => writeln s
      | NONE => writeln "Chatbot found no induction candidates"
  in () end
\<close>

section \<open>Chatbot Utilities\<close>

subsection \<open>Adversarial Greetings\<close>

ML \<open>
  (* Get a random adversarial greeting *)
  writeln (Sledgehammer_Chatbot.adversarial_greeting ())
\<close>

subsection \<open>Success Celebrations\<close>

ML \<open>
  (* Celebrate proofs with varying timing *)
  writeln "Fast proof celebration:";
  writeln (Sledgehammer_Chatbot.celebrate_success "vampire" 50);
  writeln "";
  writeln "Medium proof celebration:";
  writeln (Sledgehammer_Chatbot.celebrate_success "e" 2500);
  writeln "";
  writeln "Hard-won proof celebration:";
  writeln (Sledgehammer_Chatbot.celebrate_success "z3" 15000)
\<close>

subsection \<open>Failed Proof Mockery\<close>

ML \<open>
  (* Mock failed proof attempts *)
  writeln (Sledgehammer_Chatbot.mock_failed_proof "cvc4")
\<close>

subsection \<open>Proof Elegance Rating\<close>

ML \<open>
  (* Rate proof elegance based on fact count *)
  writeln "Elegance ratings by fact count:";
  writeln ("0 facts: " ^ Sledgehammer_Chatbot.rate_proof_elegance 0);
  writeln ("1 fact:  " ^ Sledgehammer_Chatbot.rate_proof_elegance 1);
  writeln ("5 facts: " ^ Sledgehammer_Chatbot.rate_proof_elegance 5);
  writeln ("12 facts: " ^ Sledgehammer_Chatbot.rate_proof_elegance 12);
  writeln ("25 facts: " ^ Sledgehammer_Chatbot.rate_proof_elegance 25)
\<close>

subsection \<open>Philosophical Musings\<close>

ML \<open>
  (* For contemplation during long proof searches *)
  writeln "A moment of philosophy:";
  writeln (Sledgehammer_Chatbot.philosophical_musings ())
\<close>

subsection \<open>Timeout Messages\<close>

ML \<open>
  (* Generate timeout messages *)
  writeln (Sledgehammer_Chatbot.generate_witty_timeout "vampire" (Time.fromSeconds 30))
\<close>

section \<open>Complex Theorem for Full Chatbot Experience\<close>

text \<open>
  Here's a more complex theorem that would trigger the chatbot's
  "nightmare mode" responses:
\<close>

lemma complex_demo:
  assumes "finite A" "finite B"
  shows "card (A \<union> B) + card (A \<inter> B) = card A + card B"
  using assms by (simp add: card_Un_Int)

ML \<open>
  (* Complex goal analysis *)
  let
    val tm = @{term "\<forall>A B. finite A \<longrightarrow> finite B \<longrightarrow> 
                          card (A \<union> B) + card (A \<inter> B) = card A + card B"}
    val response = Sledgehammer_Chatbot.critique_goal @{context} tm
    val _ = writeln ("Chatbot's verdict on complex goal:")
    val _ = writeln (#message response)
    val _ = writeln ("Complexity taunt level: " ^ Int.toString (#taunt_level response) ^ "/10")
  in () end
\<close>

section \<open>Chatbot Integration Summary\<close>

text \<open>
  The Inductive Sledgehammer Adversarial Chatbot provides:
  
  1. \<^bold>\<open>Goal Critique\<close>: Analyzes theorems and provides witty commentary
     based on structural complexity.
     
  2. \<^bold>\<open>Induction Detection\<close>: Identifies potential induction candidates
     (natural numbers, lists, etc.) in goal terms.
     
  3. \<^bold>\<open>Proof Feedback\<close>: Celebrates successes and mocks failures with
     appropriate levels of humor and encouragement.
     
  4. \<^bold>\<open>Elegance Rating\<close>: Rates proof quality based on the number of
     facts used (fewer is better!).
     
  5. \<^bold>\<open>Philosophy Mode\<close>: Provides existential musings during long
     proof searches.

  To use the command-line chatbot:
  \<^verbatim>\<open>isabelle sledgehammer_chatbot -i\<close>
  
  May your proofs be elegant and your lemmas well-chosen!
\<close>

end
