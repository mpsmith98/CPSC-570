sig Workstation {
	workers : set Worker,
	succ : set Workstation
}
one sig begin, end in Workstation {}

sig Worker {}
sig Human, Robot extends Worker {}

abstract sig Product {
	parts : set Product	
}

sig Material extends Product {}

sig Component extends Product {
	workstation : set Workstation
}

sig Dangerous in Product {}
// Specify the following properties.
// You can check their correctness with the different commands and
// when specifying each property you can assume all the previous ones to be true.

pred inv1 {
	// Workers are either human or robots
	all w : Worker | w in Human or w in Robot
}


pred inv2 {
	// Every workstation has workers and every worker works in one workstation
	workers in Workstation one -> some Worker
}


pred inv3 {
	// Every component is assembled in one workstation
	workstation in Component -> one Workstation
}


pred inv4 {
	// Components must have parts and materials have no parts
  	parts in Component -> some Product and
  	no Material.parts

}


pred inv5 {
	// Humans and robots cannot work together
	all ws : Workstation | some (Human & ws.workers) implies no (Robot & ws.workers)
}


pred inv6 {
	// Components cannot be their own parts
  	all c : Component | not c in c.^parts

}


pred inv7 {
	// Components built of dangerous parts are also dangerous
	all c : Component | some Dangerous & c.^parts implies c in Dangerous
}


pred inv8 {
	// Dangerous components cannot be assembled by humans
	all dc : (Component & Dangerous) | no dc.workstation.workers & Human
}


pred inv9 {
	// The workstations form a single line between begin and end
	succ in (Workstation - end) lone -> lone (Workstation - begin) and
  	all ws : Workstation | ws in begin.^succ or ws = begin
  	
}


pred inv10 {
	// The parts of a component must be assembled before it in the production line
  	all c : Component, p : c.parts & Component | c.workstation in p.workstation.^succ
}

run {
	inv1 and
	inv2 and
	inv3 and 
	inv4 and
	inv5 and
	inv6 and
	inv7 and
	inv8 and
	inv9 and
	inv10
} for 5 Workstation, 8 Worker, 8 Product
