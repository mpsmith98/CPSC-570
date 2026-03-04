----------------------------- MODULE TwoPhaseCommit_Part1 -----------------------------
(*
  Part 1: Concurrency
  
  HOMEWORK: Model the concurrent structure of Two-Phase Commit (2PC).
  
  Protocol overview:
  - Phase 1 (Prepare): Coordinator sends PREPARE to all participants.
      Each participant votes YES or NO.
  - Phase 2 (Decide): Coordinator collects votes.
      If ALL voted YES -> COMMIT. Otherwise -> ABORT.
      Participants receive the decision and update their state.
  
  YOUR TASK:
  1. Complete the Coordinator process:
     - SendPrepare: transition coordPhase from "idle" to "waiting"
     - Decide: wait until all participants have voted, then commit or abort
     - Finish: wait until all participants received the decision, then set "done"
  
  2. Complete the Participant process:
     - Vote: when the coordinator is waiting, nondeterministically vote "yes" or "no"
     - ReceiveDecision: receive commit (if voted yes and coordinator committed)
       or abort (if coordinator aborted)
  
  HINTS:
  - Use `when` to block until a condition holds
  - Use `with v \in {"yes", "no"} do ... end with` for nondeterministic choice
  - Use `either ... or ... end either` for branching on the decision
  - The helpers AllVoted, AllYes, AllDecided are provided for you
*)
EXTENDS Integers

CONSTANT NumParticipants

ASSUME NumParticipants \in 2..5

Coord == 0
Participants == 1..NumParticipants

(*--algorithm TwoPhaseCommit

variables
    (* coordPhase: "idle" -> "waiting" -> "committed"/"aborted" -> "done" *)
    coordPhase = "idle",
    (* partPhase: "idle" -> "voted" -> "committed"/"aborted" *)
    partPhase = [p \in Participants |-> "idle"],
    (* partVote: "none" -> "yes"/"no" *)
    partVote = [p \in Participants |-> "none"];

define
    AllVoted == \A p \in Participants: partPhase[p] # "idle"
    AllYes == \A p \in Participants: partVote[p] = "yes"
    AllDecided == \A p \in Participants: partPhase[p] \in {"committed", "aborted"}
end define;

fair process Coordinator = Coord
begin
    SendPrepare:
        \* TODO: Wait until coordPhase = "idle", then set it to "waiting"
        when coordPhase = "idle";
        coordPhase := "waiting";
    Decide:
        \* TODO: Wait until coordPhase = "waiting" AND AllVoted.
        \*       If AllYes, set coordPhase to "committed"; otherwise "aborted".
        when /\ coordPhase = "waiting" 
             /\ AllVoted;
        if AllYes then
            coordPhase := "committed";
        else
            coordPhase := "aborted";
        end if;
    Finish:
        \* TODO: Wait until coordinator has decided AND AllDecided.
        \*       Set coordPhase to "done".
        when /\ \/ coordPhase = "committed"
                \/ coordPhase = "aborted"
             /\ AllDecided;
        coordPhase := "done";
end process;

fair process Participant \in Participants
begin
    Vote:
        \* TODO: Wait until this participant is idle AND coordinator is waiting.
        \*       Nondeterministically choose a vote in {"yes", "no"}.
        \*       Set partPhase[self] to "voted" and partVote[self] to the chosen vote.
        when /\ partPhase[self] = "idle" 
             /\ coordPhase = "waiting";
             
        with v \in {"yes", "no"} 
        do partVote[self] := v;
        end with;
        
        partPhase[self] := "voted";
        
    ReceiveDecision:
        \* TODO: Wait for the coordinator's decision, then update partPhase[self]:
        \*       - If this participant voted "yes" AND coordinator committed -> "committed"
        \*       - If coordinator aborted -> "aborted"
        \*
        \* HINT: Use either/or to handle the two cases:
        \*   either
        \*       when <commit condition>;
        \*       partPhase[self] := "committed";
        \*   or
        \*       when <abort condition>;
        \*       partPhase[self] := "aborted";
        \*   end either;
        
        either
           when /\ coordPhase = "committed" 
                /\ partVote[self] = "yes";
           partPhase[self] := "committed";
        or
           when coordPhase = "aborted";
           partPhase[self] := "aborted";
        end either;
        
        
\*    Bug: 
\*        with v \in {"committed", "aborted"} do partPhase[self] := v; end with;
end process;

end algorithm;*)
\* BEGIN TRANSLATION (chksum(pcal) = "c70011c3" /\ chksum(tla) = "7139faa3")
VARIABLES coordPhase, partPhase, partVote, pc

(* define statement *)
AllVoted == \A p \in Participants: partPhase[p] # "idle"
AllYes == \A p \in Participants: partVote[p] = "yes"
AllDecided == \A p \in Participants: partPhase[p] \in {"committed", "aborted"}


vars == << coordPhase, partPhase, partVote, pc >>

ProcSet == {Coord} \cup (Participants)

Init == (* Global variables *)
        /\ coordPhase = "idle"
        /\ partPhase = [p \in Participants |-> "idle"]
        /\ partVote = [p \in Participants |-> "none"]
        /\ pc = [self \in ProcSet |-> CASE self = Coord -> "SendPrepare"
                                        [] self \in Participants -> "Vote"]

SendPrepare == /\ pc[Coord] = "SendPrepare"
               /\ coordPhase = "idle"
               /\ coordPhase' = "waiting"
               /\ pc' = [pc EXCEPT ![Coord] = "Decide"]
               /\ UNCHANGED << partPhase, partVote >>

Decide == /\ pc[Coord] = "Decide"
          /\ /\ coordPhase = "waiting"
             /\ AllVoted
          /\ IF AllYes
                THEN /\ coordPhase' = "committed"
                ELSE /\ coordPhase' = "aborted"
          /\ pc' = [pc EXCEPT ![Coord] = "Finish"]
          /\ UNCHANGED << partPhase, partVote >>

Finish == /\ pc[Coord] = "Finish"
          /\ /\ \/ coordPhase = "committed"
                \/ coordPhase = "aborted"
             /\ AllDecided
          /\ coordPhase' = "done"
          /\ pc' = [pc EXCEPT ![Coord] = "Done"]
          /\ UNCHANGED << partPhase, partVote >>

Coordinator == SendPrepare \/ Decide \/ Finish

Vote(self) == /\ pc[self] = "Vote"
              /\ /\ partPhase[self] = "idle"
                 /\ coordPhase = "waiting"
              /\ \E v \in {"yes", "no"}:
                   partVote' = [partVote EXCEPT ![self] = v]
              /\ partPhase' = [partPhase EXCEPT ![self] = "voted"]
              /\ pc' = [pc EXCEPT ![self] = "ReceiveDecision"]
              /\ UNCHANGED coordPhase

ReceiveDecision(self) == /\ pc[self] = "ReceiveDecision"
                         /\ \/ /\ /\ coordPhase = "committed"
                                  /\ partVote[self] = "yes"
                               /\ partPhase' = [partPhase EXCEPT ![self] = "committed"]
                            \/ /\ coordPhase = "aborted"
                               /\ partPhase' = [partPhase EXCEPT ![self] = "aborted"]
                         /\ pc' = [pc EXCEPT ![self] = "Done"]
                         /\ UNCHANGED << coordPhase, partVote >>

Participant(self) == Vote(self) \/ ReceiveDecision(self)

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == /\ \A self \in ProcSet: pc[self] = "Done"
               /\ UNCHANGED vars

Next == Coordinator
           \/ (\E self \in Participants: Participant(self))
           \/ Terminating

Spec == /\ Init /\ [][Next]_vars
        /\ WF_vars(Coordinator)
        /\ \A self \in Participants : WF_vars(Participant(self))

Termination == <>(\A self \in ProcSet: pc[self] = "Done")

\* END TRANSLATION 

=============================================================================
