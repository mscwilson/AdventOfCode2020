# Specifically, they need you to find the two entries that sum to 2020 and then multiply those two numbers together.

# For example, suppose your expense report contained the following:

# 1721
# 979
# 366
# 299
# 675
# 1456

# In this list, the two entries that sum to 2020 are 1721 and 299. Multiplying them together produces 1721 * 299 = 514579, so the correct answer is 514579.

# Of course, your expense report is much larger. Find the two entries that sum to 2020; what do you get if you multiply them together?

full_list = %w[

1778
1845
1813
1889
1939
1635
1443
796
1799
938
1488
1922
1909
1258
1659
1959
1557
1085
1379
1174
1782
1482
1702
1180
1992
1815
1802
215
1649
782
1847
1673
1823
1836
1447
1603
1767
1891
1964
1881
1637
1229
1994
1901
1583
1918
1415
1666
1155
1446
1315
1345
1948
1427
1242
1088
807
1747
1514
1351
1791
1612
1550
1926
1455
85
1594
1965
1884
1677
1960
1631
1585
1472
1263
1566
1998
1698
1968
1927
1378
1346
1710
1921
1827
1869
1187
1985
1323
1225
1474
1179
1580
1098
1737
1483
1665
1445
1979
1754
1854
1897
1405
1912
1614
1390
1773
1493
1333
1758
1867
1586
1347
1723
1285
394
1743
1252
320
1547
1804
1899
1526
1739
1533
1938
1081
1465
1920
1265
1470
1792
1118
1842
1204
1760
1663
893
1853
1244
1256
1428
1334
1967
1249
1752
1124
1725
1949
1340
1205
1584
548
1947
2002
1993
1931
1236
1154
1572
1650
1678
1944
1868
1129
1911
1106
1900
1240
1955
1219
1893
1459
1556
1173
1924
1568
1950
1303
1886
1365
1402
1711
1706
1671
1866
1403
1816
1717
1674
1487
1840
1951
1255
1786
1111
1280
1625
1478
1453
]

full_list_nums = full_list.map(&:to_i)
# p full_list_nums




# full_list_nums.each_with_index do |num, i|
#   # p num
#   temp_list = full_list_nums[i+1..-1]

#   # p temp_list
# temp_list.each do |temp_list_num|
#   if num + temp_list_num == 2020
#     p num * temp_list_num
#   end
#   end
# end




nums = [1721, 979, 366, 299, 675, 1465]

full_list_nums.each_with_index do |num, i|
  # p num
  one_shorter_list = full_list_nums[i+1..-1]

    
  one_shorter_list.each_with_index do |one_shorter_list_num, i|
    two_shorter_list = one_shorter_list[i+1..-1]

    two_shorter_list.each do |two_shorter_list_num|

      if num + one_shorter_list_num + two_shorter_list_num == 2020
      p num * one_shorter_list_num * two_shorter_list_num
      end
    end
  end
end




