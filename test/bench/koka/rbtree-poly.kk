// Adapted from https://github.com/leanprover/lean4/blob/IFL19/tests/bench/rbmap.lean

type color { Red Black }
type tree<k,v> {
  con Leaf()
  con Node(color: color, lchild: tree<k,v>, key: k, value: v, rchild: tree<k,v>)
}

fun fold(t: tree<k,v>, b: a, f: (k, v, a) -> a): a {
  match (t) {
    Leaf
      -> /* drop(f,t) */
         b
    Node(_, l, k, v, r)
      -> /* dup(k,l,r) drop(t) */
         r.fold((/* dup */ f)(k, v, l.fold(b, f)), f)
  }
}

fun balance1(kv: k, vv: v, t: tree<k,v>, s: tree<k,v>): tree<k,v> {
  match(s) {
    Node(_, Node(Red, l, kx, vx, r1), ky, vy, r2)
      -> Node(Red, Node(Black, l, kx, vx, r1), ky, vy, Node(Black, r2, kv, vv, t))
    Node(_, l1, ky, vy, Node(Red, l2, kx, vx, r))
      -> Node(Red, Node(Black, l1, ky, vy, l2), kx, vx, Node(Black, r, kv, vv, t))
    Node(_, l, ky, vy, r)
      -> Node(Black, Node(Red, l, ky, vy, r), kv, vv, t)
    _ -> Leaf
  }
}

fun balance2(t: tree<k,v>, kv: k, vv: v, s: tree<k,v>): tree<k,v> {
  match(s) {
    Node(_, Node(Red, l, kx1, vx1, r1), ky, vy, r2)
      -> Node(Red, Node(Black, t, kv, vv, l), kx1, vx1, Node(Black, r1, ky, vy, r2))
    Node(_, l1, ky, vy, Node(Red, l2, kx2, vx2, r2))
      -> Node(Red, Node(Black, t, kv, vv, l1), ky, vy, Node(Black, l2, kx2, vx2, r2))
    Node(_, l, ky, vy, r)
      -> Node(Black, t, kv, vv, Node(Red, l, ky, vy, r))
    _ -> Leaf
  }
}

fun is-red(t : tree<k,v>) : bool {
  match(t) {
    Node(Red) -> True
    _         -> False
  }
}

fun ins(t: tree<int,v>, kx: int, vx: v): tree<int,v> {
  match(t) {
    Leaf 
      -> Node(Red, Leaf, kx, vx, Leaf)
    Node(Red, a, ky, vy, b)
      -> if (kx < ky) then Node(Red, ins(a, kx, vx), ky, vy, b)
         elif (kx == ky) then Node(Red, a, kx, vx, b)
         else Node(Red, a, ky, vy, ins(b, kx, vx))
    Node(Black, a, ky, vy, b)
      -> if (kx < ky && is-red(a)) then balance1(ky, vy, b, ins(a, kx, vx))
         elif (kx < ky) then Node(Black, ins(a, kx, vx), ky, vy, b)
         elif (kx == ky) then Node(Black, a, kx, vx, b)
         elif (is-red(b)) then balance2(a, ky, vy, ins(b, kx, vx))
         else Node(Black, a, ky, vy, ins(b, kx, vx))
  }

  /* match(t) {
    Leaf -> Node(Red, Leaf, kx, vx, Leaf)
    Node(Red, a, ky, vy, b)
      | kx < ky  -> Node(Red, ins(a, kx, vx), ky, vy, b)
      | kx == ky -> Node(Red, a, kx, vx, b)
      | True -> Node(Red, a, ky, vy, ins(b, kx, vx))
    Node(Black, a, ky, vy, b)
      | kx < ky && isRed(a) -> balance1(ky, vy, b, ins(a, kx, vx))
      | kx < ky -> Node(Black, ins(a, kx, vx), ky, vy, b)
      | kx == ky -> Node(Black, a, kx, vx, b)
      | isRed(b) -> balance2(a, ky, vy, ins(b, kx, vx))
      | True -> Node(Black, a, ky, vy, ins(b, kx, vx))
  } */
}

fun set-black(t: tree<k,v>) : tree<k,v> {
  match(t) {
    Node(_, l, k, v, r) -> Node(Black, l, k, v, r)
    _ -> t
  }
}

fun insert(t: tree<int,v>, k: int, v: v): tree<int,v> {
  if (is-red(t))
    then set-black(ins(t, k, v))
    else ins(t, k, v)
}

fun make-tree-aux(n: int, m: tree<int,bool>): div tree<int,bool> {
  if (n <= 0) then m else {
    val n1 = n - 1
    make-tree-aux(n1, insert(m, n1, n1 % 10 == 0))
  }
}

fun make-tree(n: int): div tree<int,bool> {
  make-tree-aux(n, Leaf)
}

fun main() {
  val m = make-tree(4200000); // todo: read first command line arg for size
  val v = m.fold(0) fun(k, v, r) { if (v) then r + 1 else r }
  v.println
}
