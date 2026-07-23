(*  Title:      HOL/Tools/Sledgehammer/sledgehammer_chatbot.ML
    Author:     Hilarious Adversarial Theorem Prover (H.A.T.P.)

Inductive Sledgehammer Adversarial Chatbot - A playfully antagonistic
theorem proving assistant that challenges users to think harder about
their proofs while providing genuinely helpful guidance.

"Every theorem proven without struggle is a theorem learned without depth."
                                        -- Ancient Prover Wisdom (fabricated)
*)

signature SLEDGEHAMMER_CHATBOT =
sig
  type chatbot_response = {
    message: string,
    suggestion: string option,
    taunt_level: int,
    proof_hint: string option
  }

  val adversarial_greeting : unit -> string
  val critique_goal : Proof.context -> term -> chatbot_response
  val mock_failed_proof : string -> string
  val celebrate_success : string -> int -> string
  val suggest_induction : Proof.context -> term -> string option
  val generate_witty_timeout : string -> Time.time -> string
  val challenge_assumptions : (string * thm) list -> string
  val rate_proof_elegance : int -> string
  val philosophical_musings : unit -> string
end;

structure Sledgehammer_Chatbot : SLEDGEHAMMER_CHATBOT =
struct

open ATP_Util
open Sledgehammer_Util

type chatbot_response = {
  message: string,
  suggestion: string option,
  taunt_level: int,
  proof_hint: string option
}

(* Adversarial greetings to set the tone *)
val greetings = [
  "Ah, another brave soul enters the arena of formal verification! Let's see what you've got.",
  "Welcome, mortal! I am the Inductive Sledgehammer. Your theorems shall be tested.",
  "Oh good, fresh meat for the type checker. What impossible thing shall we prove today?",
  "Greetings, proof warrior! May your lemmas be strong and your assumptions weak.",
  "The Sledgehammer awakens! Present your conjectures and prepare for rigorous scrutiny.",
  "Behold! A theorem-seeker approaches. I've crushed better propositions than yours before breakfast.",
  "Welcome to the proof pit! Where every 'obviously true' becomes 'surprisingly complex'.",
  "Ah yes, another human who thinks mathematics should be 'intuitive'. How adorable.",
  "Ready your tactics, sharpen your simplifications! The battle for truth begins!",
  "I sense a disturbance in the type system... Oh, it's just you with another proof attempt."
]

fun adversarial_greeting () =
  let val n = Time.toMicroseconds (Time.now ()) mod List.length greetings
  in List.nth (greetings, Int.fromLarge n) end

(* Analyze goal structure for witty commentary *)
fun goal_complexity tm =
  let
    fun count_depth (Abs (_, _, t)) = 1 + count_depth t
      | count_depth (t $ u) = Int.max (count_depth t, count_depth u) + 1
      | count_depth _ = 0
    fun count_vars (Free _) = 1
      | count_vars (Var _) = 1
      | count_vars (Abs (_, _, t)) = count_vars t
      | count_vars (t $ u) = count_vars t + count_vars u
      | count_vars _ = 0
  in (count_depth tm, count_vars tm) end

val trivial_responses = [
  "Really? THAT'S your theorem? Even a first-year student could prove this with 'auto'.",
  "Ah, I see we're starting easy. Nothing wrong with warm-up exercises, I suppose.",
  "This goal is so simple it's almost insulting. But I'll play along.",
  "Bold of you to disturb my slumber for something this straightforward.",
  "*yawns* Call me when you have a REAL challenge."
]

val moderate_responses = [
  "Now THIS is more like it! A goal with some actual substance.",
  "Interesting... You might actually need to think about this one.",
  "A worthy opponent appears! This theorem has teeth.",
  "Oho! Someone's been reading their textbooks. This requires finesse.",
  "Not bad, not bad. This one might take more than just 'simp'."
]

val complex_responses = [
  "By the axiom of choice! This is a beast of a theorem!",
  "Now we're talking! This is the kind of challenge I live for!",
  "Hold onto your proof obligations - this one's going to be a ride!",
  "I... actually respect this goal. Don't let it go to your head.",
  "Finally! A theorem worthy of the Sledgehammer's full power!"
]

val nightmare_responses = [
  "Sweet mother of metamathematics! What have you unleashed upon this poor proof assistant?",
  "I need to sit down. And I'm a disembodied theorem prover.",
  "This... this is either brilliance or madness. Possibly both.",
  "The ancient texts spoke of theorems like this. I thought they were myths.",
  "We're going to need a bigger sledgehammer."
]

fun critique_goal ctxt tm =
  let
    val (depth, vars) = goal_complexity tm
    val complexity_score = depth + vars
    val (responses, taunt) =
      if complexity_score < 5 then (trivial_responses, 1)
      else if complexity_score < 15 then (moderate_responses, 3)
      else if complexity_score < 30 then (complex_responses, 5)
      else (nightmare_responses, 10)
    val n = Time.toMicroseconds (Time.now ()) mod List.length responses
    val msg = List.nth (responses, Int.fromLarge n)
    
    (* Generate a proof hint based on goal structure *)
    val hint =
      if Term.exists_subterm (fn Const (\<^const_name>\<open>Suc\<close>, _) => true | _ => false) tm
      then SOME "I spy natural numbers... Have you considered induction?"
      else if Term.exists_subterm (fn Const (\<^const_name>\<open>Cons\<close>, _) => true | _ => false) tm
      then SOME "Lists detected! Structural induction might be your friend here."
      else if complexity_score > 20
      then SOME "This monster might yield to divide-and-conquer. Try breaking it into lemmas."
      else NONE
      
    val suggestion =
      if complexity_score < 5 then SOME "try0"
      else if complexity_score < 10 then SOME "auto"
      else if complexity_score < 20 then SOME "sledgehammer"
      else SOME "sledgehammer [timeout = 120]"
  in
    {message = msg, suggestion = suggestion, taunt_level = taunt, proof_hint = hint}
  end

(* Mock failed proof attempts with style *)
val failure_mockery = [
  "Oh dear. That proof attempt crashed and burned like a theorem with unstated assumptions.",
  "Task failed successfully! ...Wait, that's not how theorems work.",
  "Your proof fell apart faster than a house of cards in a windstorm of counterexamples.",
  "Metis said 'no'. Actually, it said something much more technical, but the gist was 'no'.",
  "The ATPs have spoken, and they are NOT impressed.",
  "Proof not found. Have you tried believing harder?",
  "Error 404: Valid proof not found. The theorem remains unconvinced.",
  "Your proof attempt has been weighed, measured, and found wanting.",
  "The sledgehammer has swung and missed. Even mighty tools have their limits.",
  "Witnesses? Counterexamples? The only witness here is me, witnessing this failure."
]

fun mock_failed_proof prover_name =
  let
    val n = Time.toMicroseconds (Time.now ()) mod List.length failure_mockery
    val base = List.nth (failure_mockery, Int.fromLarge n)
  in
    base ^ "\n[" ^ prover_name ^ " couldn't find a proof - but don't give up! "
    ^ "Even Gödel couldn't prove everything.]"
  end

(* Celebrate successes with appropriate levels of grudging admiration *)
fun celebrate_success prover_name time_ms =
  let
    val fast_celebrations = [
      "Well well well, " ^ prover_name ^ " demolished that in " ^ 
        Int.toString time_ms ^ "ms! Show off.",
      "Boom! " ^ prover_name ^ " didn't even break a sweat. " ^ Int.toString time_ms ^ "ms!",
      prover_name ^ " says: 'Is that all you've got?' (" ^ Int.toString time_ms ^ "ms)",
      "Victory in " ^ Int.toString time_ms ^ "ms! " ^ prover_name ^ " demands a harder challenge!",
      "QED in " ^ Int.toString time_ms ^ "ms. " ^ prover_name ^ " is now taking a nap."
    ]
    val medium_celebrations = [
      prover_name ^ " found a proof in " ^ Int.toString time_ms ^ "ms. Respectable!",
      "Success! " ^ prover_name ^ " wrestled that theorem into submission. (" ^ 
        Int.toString time_ms ^ "ms)",
      "The proof is complete! " ^ Int.toString time_ms ^ "ms of glorious computation.",
      prover_name ^ " triumphs after " ^ Int.toString time_ms ^ "ms of existential contemplation."
    ]
    val hard_celebrations = [
      prover_name ^ " FINALLY found it after " ^ Int.toString time_ms ^ 
        "ms! I was starting to worry.",
      "Against all odds, " ^ prover_name ^ " prevails! (" ^ Int.toString time_ms ^ "ms of struggle)",
      "Victory is ours! " ^ Int.toString time_ms ^ "ms of proof search well spent.",
      "The impossible has been proven possible! " ^ prover_name ^ " deserves a medal. (" ^ 
        Int.toString time_ms ^ "ms)"
    ]
    val celebrations =
      if time_ms < 100 then fast_celebrations
      else if time_ms < 5000 then medium_celebrations
      else hard_celebrations
    val n = Time.toMicroseconds (Time.now ()) mod List.length celebrations
  in List.nth (celebrations, Int.fromLarge n) end

(* Suggest induction schemes based on term structure *)
fun suggest_induction ctxt tm =
  let
    fun find_inductables (Free (name, Type (\<^type_name>\<open>nat\<close>, []))) = [name ^ " (natural number)"]
      | find_inductables (Free (name, Type (\<^type_name>\<open>list\<close>, _))) = [name ^ " (list)"]
      | find_inductables (Free (name, Type ("Set.set", _))) = [name ^ " (set - careful!)"]
      | find_inductables (t $ u) = find_inductables t @ find_inductables u
      | find_inductables (Abs (_, _, t)) = find_inductables t
      | find_inductables _ = []
    val candidates = find_inductables tm |> distinct (op =)
  in
    case candidates of
      [] => NONE
    | [x] => SOME ("The spirits of induction whisper: try induction on " ^ x ^ 
                   ".\nCommand: (induct " ^ hd (space_explode " " x) ^ ")")
    | xs => SOME ("Multiple induction candidates detected! Consider:\n" ^
                  String.concatWith "\n" (map (fn x => "  - " ^ x) xs) ^
                  "\nChoose wisely, young prover. Or don't - I'll mock you either way.")
  end

(* Timeout messages with varying levels of sympathy *)
val timeout_messages = [
  "Time's up! %PROVER% ran out of patience after %TIME%s. The theorem remains defiant.",
  "Tick tock! %PROVER% couldn't crack it in %TIME%s. The proof space is vast indeed.",
  "%PROVER% timed out at %TIME%s. Some theorems just want to watch the world burn.",
  "The hourglass is empty. %PROVER% searched %TIME%s and found only existential dread.",
  "%TIME% seconds of computation, zero proofs found. %PROVER% suggests trying a different approach.",
  "Timeout after %TIME%s! Even %PROVER%'s legendary patience has limits.",
  "%PROVER% stared into the proof space for %TIME%s. The proof space stared back.",
  "The clock ran out on %PROVER% at %TIME%s. Perhaps more lemmas are needed?"
]

fun generate_witty_timeout prover timeout =
  let
    val n = Time.toMicroseconds (Time.now ()) mod List.length timeout_messages
    val template = List.nth (timeout_messages, Int.fromLarge n)
    val time_str = Real.fmt (StringCvt.FIX (SOME 1)) (Time.toReal timeout)
  in
    template
    |> String.translate (fn c => str c)
    |> (fn s => String.concatWith prover (String.tokens (fn c => c = #"%") s))
    |> (fn s =>
         String.map (fn #"T" => #" " | #"I" => #" " | #"M" => #" " | #"E" => #" " | c => c) s)
    (* Simple substitution since we can't use regexp easily *)
    |> (fn _ => 
         String.concatWith prover 
           (String.tokens (fn c => c = #"%") template)
         |> (fn s => if String.isSubstring "TIME" s 
                     then String.concatWith time_str 
                            [String.extract (s, 0, SOME (String.size s - 4)), ""]
                     else s))
  in
    template
    |> (fn s => String.translate (fn #"%" => "" | c => str c) s)
    |> (fn _ => (String.concatWith prover (String.fields (fn c => c = #"%") 
                  (String.concatWith time_str (String.fields (fn c => c = #"%") template)))))
  end
  handle _ => prover ^ " timed out after " ^ 
              Real.fmt (StringCvt.FIX (SOME 1)) (Time.toReal timeout) ^ "s. Better luck next time!"

(* Challenge the assumptions being used *)
val assumption_challenges = [
  "I see you're using %N% fact(s). Are you SURE they're all necessary?",
  "Interesting choice of lemmas... %N% facts seems like %ASSESSMENT%.",
  "Your proof depends on %N% external facts. The minimizer judges you silently.",
  "%N% facts! Back in my day, we proved things from first principles!",
  "A proof using %N% facts is either elegant or desperate. Time will tell."
]

fun challenge_assumptions facts =
  let
    val n = List.length facts
    val assessment = 
      if n = 0 then "bold minimalism"
      else if n < 3 then "admirable restraint"
      else if n < 10 then "reasonable"
      else if n < 20 then "perhaps excessive"
      else "proof by overwhelming firepower"
    val idx = Time.toMicroseconds (Time.now ()) mod List.length assumption_challenges
    val template = List.nth (assumption_challenges, Int.fromLarge idx)
  in
    template
    |> (fn s => String.concatWith (Int.toString n) (String.fields (fn c => c = #"%") s))
    |> (fn s => String.concatWith assessment (String.fields (fn c => c = #"%") s))
  end
  handle _ => Int.toString (List.length facts) ^ " facts used. Make of that what you will."

(* Rate proof elegance based on fact count *)
fun rate_proof_elegance fact_count =
  if fact_count = 0 then
    "★★★★★ LEGENDARY! A proof from pure logic! You absolute unit!"
  else if fact_count = 1 then
    "★★★★☆ Excellent! A single lemma proof - the mathematician's ideal."
  else if fact_count <= 3 then
    "★★★☆☆ Good. Clean and efficient. Your advisor would be proud."
  else if fact_count <= 7 then
    "★★☆☆☆ Acceptable. It works, but there's room for elegance."
  else if fact_count <= 15 then
    "★☆☆☆☆ Questionable. Did you just throw facts at it until something stuck?"
  else
    "☆☆☆☆☆ Concerning. This is less a proof and more a bibliography."

(* Philosophical musings for when provers are thinking *)
val philosophical = [
  "What IS a theorem, really? A truth waiting to be discovered, or a construct of our axioms?",
  "In an infinite proof space, every search is simultaneously futile and meaningful.",
  "The prover ponders: if a theorem is proven in a forest of lemmas, does it make a sound?",
  "Gödel showed us the limits of provability. And yet, we persist. Foolish? Or noble?",
  "Every timeout is a reminder that computation is finite, but mathematics is eternal.",
  "Consider: the theorem you seek to prove has always been true. You merely wish to know it.",
  "The ATPs search not for truth, but for evidence of truth. A subtle but crucial distinction.",
  "In the grand tapestry of mathematics, your proof is but a single thread. Make it count.",
  "Remember: behind every 'auto' is centuries of human mathematical insight, distilled.",
  "The Curry-Howard correspondence suggests: to prove is to program, to program is to prove.",
  "We stand on the shoulders of giants: Aristotle, Frege, Gödel, and whoever wrote 'simp'.",
  "Some say mathematics is discovered. Others say invented. The prover merely... searches."
]

fun philosophical_musings () =
  let val n = Time.toMicroseconds (Time.now ()) mod List.length philosophical
  in List.nth (philosophical, Int.fromLarge n) end

end;
