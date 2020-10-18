echo -e "Id\tName\n0\tA\n1\tB" | ./th_row.sh
echo -e "Id\t0\t1\nName\tA\tB" | ./th_column.sh
echo -e "\tA\tB\n1\tX\tY\n2\ta\tb" | ./th_row_column.sh

