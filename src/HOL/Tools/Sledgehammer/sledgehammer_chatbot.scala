/*  Title:      HOL/Tools/Sledgehammer/sledgehammer_chatbot.scala
    Author:     Hilarious Adversarial Theorem Prover (H.A.T.P.)

Scala interface for the Inductive Sledgehammer Adversarial Chatbot.
Provides an interactive command-line experience for theorem proving
with humorous commentary.
*/

package isabelle


object Sledgehammer_Chatbot {
  /* Chatbot personality traits and response generators */

  private val random = new scala.util.Random(System.currentTimeMillis())

  object Greetings {
    val messages: List[String] = List(
      "Ah, another brave soul enters the arena of formal verification! Let's see what you've got.",
      "Welcome, mortal! I am the Inductive Sledgehammer. Your theorems shall be tested.",
      "Oh good, fresh meat for the type checker. What impossible thing shall we prove today?",
      "Greetings, proof warrior! May your lemmas be strong and your assumptions weak.",
      "The Sledgehammer awakens! Present your conjectures and prepare for rigorous scrutiny.",
      "Behold! A theorem-seeker approaches. I've crushed better propositions before breakfast.",
      "Welcome to the proof pit! Where every 'obviously true' becomes 'surprisingly complex'.",
      "Ah yes, another human who thinks mathematics should be 'intuitive'. How adorable.",
      "Ready your tactics, sharpen your simplifications! The battle for truth begins!",
      "I sense a disturbance in the type system... Oh, it's just you with another proof attempt."
    )

    def random_greeting: String = messages(random.nextInt(messages.length))
  }

  object Taunts {
    val trivial: List[String] = List(
      "Really? THAT'S your theorem? Even a first-year student could prove this with 'auto'.",
      "Ah, I see we're starting easy. Nothing wrong with warm-up exercises, I suppose.",
      "This goal is so simple it's almost insulting. But I'll play along.",
      "Bold of you to disturb my slumber for something this straightforward.",
      "*yawns* Call me when you have a REAL challenge."
    )

    val moderate: List[String] = List(
      "Now THIS is more like it! A goal with some actual substance.",
      "Interesting... You might actually need to think about this one.",
      "A worthy opponent appears! This theorem has teeth.",
      "Oho! Someone's been reading their textbooks. This requires finesse.",
      "Not bad, not bad. This one might take more than just 'simp'."
    )

    val complex: List[String] = List(
      "By the axiom of choice! This is a beast of a theorem!",
      "Now we're talking! This is the kind of challenge I live for!",
      "Hold onto your proof obligations - this one's going to be a ride!",
      "I... actually respect this goal. Don't let it go to your head.",
      "Finally! A theorem worthy of the Sledgehammer's full power!"
    )

    val nightmare: List[String] = List(
      "Sweet mother of metamathematics! What have you unleashed?",
      "I need to sit down. And I'm a disembodied theorem prover.",
      "This... this is either brilliance or madness. Possibly both.",
      "The ancient texts spoke of theorems like this. I thought they were myths.",
      "We're going to need a bigger sledgehammer."
    )

    def for_complexity(score: Int): String = {
      val pool =
        if (score < 5) trivial
        else if (score < 15) moderate
        else if (score < 30) complex
        else nightmare
      pool(random.nextInt(pool.length))
    }
  }

  object Failures {
    val messages: List[String] = List(
      "Oh dear. That proof crashed and burned like a theorem with unstated assumptions.",
      "Task failed successfully! ...Wait, that's not how theorems work.",
      "Your proof fell apart like a house of cards in a windstorm of counterexamples.",
      "Metis said 'no'. Actually, something more technical, but the gist was 'no'.",
      "The ATPs have spoken, and they are NOT impressed.",
      "Proof not found. Have you tried believing harder?",
      "Error 404: Valid proof not found. The theorem remains unconvinced.",
      "Your proof attempt has been weighed, measured, and found wanting.",
      "The sledgehammer has swung and missed. Even mighty tools have their limits.",
      "The only witness here is me, witnessing this failure."
    )

    def random_mockery(prover: String): String = {
      val base = messages(random.nextInt(messages.length))
      s"$base\n[$prover couldn't find a proof - but don't give up! Even Gödel couldn't prove everything.]"
    }
  }

  object Successes {
    def celebrate(prover: String, time_ms: Long): String = {
      val fast = List(
        s"Well well well, $prover demolished that in ${time_ms}ms! Show off.",
        s"Boom! $prover didn't even break a sweat. ${time_ms}ms!",
        s"$prover says: 'Is that all you've got?' (${time_ms}ms)",
        s"Victory in ${time_ms}ms! $prover demands a harder challenge!",
        s"QED in ${time_ms}ms. $prover is now taking a nap."
      )
      val medium = List(
        s"$prover found a proof in ${time_ms}ms. Respectable!",
        s"Success! $prover wrestled that theorem into submission. (${time_ms}ms)",
        s"The proof is complete! ${time_ms}ms of glorious computation.",
        s"$prover triumphs after ${time_ms}ms of existential contemplation."
      )
      val hard = List(
        s"$prover FINALLY found it after ${time_ms}ms! I was starting to worry.",
        s"Against all odds, $prover prevails! (${time_ms}ms of struggle)",
        s"Victory is ours! ${time_ms}ms of proof search well spent.",
        s"The impossible has been proven! $prover deserves a medal. (${time_ms}ms)"
      )

      val pool =
        if (time_ms < 100) fast
        else if (time_ms < 5000) medium
        else hard
      pool(random.nextInt(pool.length))
    }
  }

  object Philosophy {
    val musings: List[String] = List(
      "What IS a theorem, really? A truth waiting to be discovered?",
      "In an infinite proof space, every search is simultaneously futile and meaningful.",
      "If a theorem is proven in a forest of lemmas, does it make a sound?",
      "Gödel showed us the limits of provability. And yet, we persist.",
      "Every timeout reminds us: computation is finite, mathematics is eternal.",
      "Consider: the theorem has always been true. You merely wish to know it.",
      "The ATPs search not for truth, but for evidence of truth.",
      "In the grand tapestry of mathematics, your proof is but a single thread.",
      "Behind every 'auto' is centuries of human mathematical insight, distilled.",
      "The Curry-Howard correspondence: to prove is to program, to program is to prove.",
      "We stand on giants: Aristotle, Frege, Gödel, and whoever wrote 'simp'.",
      "Some say mathematics is discovered. Others say invented. The prover... searches."
    )

    def random_musing: String = musings(random.nextInt(musings.length))
  }

  object Induction {
    def suggest(has_nat: Boolean, has_list: Boolean, has_set: Boolean): Option[String] = {
      val candidates = List(
        if (has_nat) Some("a natural number variable") else None,
        if (has_list) Some("a list variable") else None,
        if (has_set) Some("a set variable (tread carefully!)") else None
      ).flatten

      candidates match {
        case Nil => None
        case List(x) =>
          Some(s"The spirits of induction whisper: try induction on $x.")
        case xs =>
          Some(s"Multiple induction candidates detected!\n${xs.map("  - " + _).mkString("\n")}\n" +
               "Choose wisely, young prover. Or don't - I'll mock you either way.")
      }
    }
  }

  object Elegance {
    def rate(fact_count: Int): String = fact_count match {
      case 0 => "★★★★★ LEGENDARY! A proof from pure logic! You absolute unit!"
      case 1 => "★★★★☆ Excellent! A single lemma proof - the mathematician's ideal."
      case n if n <= 3 => "★★★☆☆ Good. Clean and efficient. Your advisor would be proud."
      case n if n <= 7 => "★★☆☆☆ Acceptable. It works, but there's room for elegance."
      case n if n <= 15 => "★☆☆☆☆ Questionable. Did you throw facts at it until something stuck?"
      case _ => "☆☆☆☆☆ Concerning. This is less a proof and more a bibliography."
    }
  }

  object Timeouts {
    def mock(prover: String, seconds: Double): String = {
      val templates = List(
        s"Time's up! $prover ran out of patience after ${seconds}s. The theorem remains defiant.",
        s"Tick tock! $prover couldn't crack it in ${seconds}s. The proof space is vast indeed.",
        s"$prover timed out at ${seconds}s. Some theorems just want to watch the world burn.",
        s"The hourglass is empty. $prover searched ${seconds}s and found only existential dread.",
        s"${seconds}s of computation, zero proofs. $prover suggests a different approach.",
        s"Timeout after ${seconds}s! Even $prover's legendary patience has limits.",
        s"$prover stared into the proof space for ${seconds}s. The proof space stared back."
      )
      templates(random.nextInt(templates.length))
    }
  }


  /* Tool implementation */

  val isabelle_tool = Isabelle_Tool("sledgehammer_chatbot", "adversarial theorem proving assistant",
    Scala_Project.here,
    { args =>
      var interactive = false

      val getopts = Getopts("""
Usage: isabelle sledgehammer_chatbot [OPTIONS]

  Options are:
    -i           interactive mode with REPL

  The Inductive Sledgehammer Adversarial Chatbot provides humorous
  commentary on your theorem proving adventures. It challenges your
  assumptions, mocks your failures (gently), and celebrates your
  victories with appropriate levels of grudging admiration.

  "Every theorem proven without struggle is a theorem learned without depth."
                                          -- Ancient Prover Wisdom
""",
        "i" -> (_ => interactive = true))

      val more_args = getopts(args)
      if (more_args.nonEmpty) getopts.usage()

      val progress = new Console_Progress()

      progress.echo(Greetings.random_greeting)
      progress.echo("")

      if (interactive) {
        progress.echo("=== INTERACTIVE MODE ===")
        progress.echo("Commands: 'help', 'taunt', 'philosophy', 'rate <n>', 'quit'")
        progress.echo("")

        var running = true
        while (running) {
          print("sledgehammer> ")
          val input = scala.io.StdIn.readLine()
          
          if (input == null || input.trim.toLowerCase == "quit" || input.trim.toLowerCase == "exit") {
            progress.echo("\nFarewell, proof warrior! May your theorems always terminate.")
            running = false
          }
          else if (input.trim.toLowerCase == "help") {
            progress.echo("""
Available commands:
  taunt              - Get a random taunt based on difficulty
  taunt <1-100>      - Get a taunt for specific complexity score
  philosophy         - Receive wisdom from the proof gods
  rate <n>           - Rate proof elegance based on fact count
  induction          - Get induction suggestions
  celebrate <ms>     - Celebrate a proof success
  mock               - Mock a failed proof attempt
  greeting           - Get a fresh adversarial greeting
  help               - Show this help
  quit/exit          - Leave the chatbot
""")
          }
          else if (input.trim.toLowerCase == "taunt") {
            progress.echo(Taunts.for_complexity(random.nextInt(40)))
          }
          else if (input.trim.toLowerCase.startsWith("taunt ")) {
            val score = input.trim.substring(6).trim.toIntOption.getOrElse(15)
            progress.echo(Taunts.for_complexity(score))
          }
          else if (input.trim.toLowerCase == "philosophy") {
            progress.echo(Philosophy.random_musing)
          }
          else if (input.trim.toLowerCase.startsWith("rate ")) {
            val count = input.trim.substring(5).trim.toIntOption.getOrElse(5)
            progress.echo(Elegance.rate(count))
          }
          else if (input.trim.toLowerCase == "induction") {
            Induction.suggest(
              random.nextBoolean(),
              random.nextBoolean(),
              random.nextBoolean()
            ) match {
              case Some(suggestion) => progress.echo(suggestion)
              case None => progress.echo("No obvious induction candidates. Try harder!")
            }
          }
          else if (input.trim.toLowerCase.startsWith("celebrate")) {
            val ms = input.trim.toLowerCase.stripPrefix("celebrate").trim.toLongOption.getOrElse(500L)
            progress.echo(Successes.celebrate("vampire", ms))
          }
          else if (input.trim.toLowerCase == "mock") {
            progress.echo(Failures.random_mockery("e"))
          }
          else if (input.trim.toLowerCase == "greeting") {
            progress.echo(Greetings.random_greeting)
          }
          else if (input.trim.nonEmpty) {
            progress.echo(s"Unknown command: '${input.trim}'. Type 'help' for options.")
          }
          progress.echo("")
        }
      }
      else {
        progress.echo("Use -i for interactive mode, or see 'isabelle sledgehammer_chatbot -?'")
        progress.echo("")
        progress.echo("Quick sample of chatbot capabilities:")
        progress.echo("")
        progress.echo("Taunt: " + Taunts.for_complexity(20))
        progress.echo("")
        progress.echo("Philosophy: " + Philosophy.random_musing)
        progress.echo("")
        progress.echo("Elegance Rating (5 facts): " + Elegance.rate(5))
      }
    })
}

class Sledgehammer_Chatbot_Tools extends Isabelle_Scala_Tools(Sledgehammer_Chatbot.isabelle_tool)
