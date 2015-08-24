// Compute coordinates on a torus n by n


int sum_modn (int a, int b, int n) {
  int res = (a+b)%n;
  if ((a+b) < 0) res = ((a+b)*(1-n))%n; // this assumes n > 1
    return res;
}

int[] coord_modn (int i, int j, int[] coord_shift, int n) {
  int res_i = sum_modn (i, coord_shift[0], n);
  int res_j = sum_modn (j, coord_shift[1], n);
  int[] res = {res_i, res_j};
  return res;
}


