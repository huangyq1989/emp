package test;

import org.apache.commons.lang3.StringUtils;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

public class test {

        public static List<String> retainElementList(List<List<String>> elementLists) {

                Optional<List<String>> result = elementLists.parallelStream()
                        .filter(elementList -> elementList != null && ((List) elementList).size() != 0)
                        .reduce((a, b) -> {
                                a.retainAll(b);
                                return a;
                        });
                return result.orElse(new ArrayList<>());
        }


    public static void main(String[] args){
//        BigDecimal sk = new BigDecimal("0.00000089").setScale(2,BigDecimal.ROUND_HALF_UP);;
//        System.out.println(sk);

//                String sdjs = "锁定解锁";
//            String us = StringUtils.substringBefore(sdjs, "-");
//            String us2 = StringUtils.substringAfter(sdjs, "-");
//            System.out.println(us+"      ######   "+us2);

//            BigDecimal a = new BigDecimal("100");
//            BigDecimal b = new BigDecimal("0");
//            System.out.println(a.subtract(b));
//            System.out.println(a.compareTo(b));

            List<String> list1 = new ArrayList<String>();
            list1.add("1");
            list1.add("2");
            list1.add("3");
            list1.add("33");
            list1.add("5");
            list1.add("6");

////            for(String ii : list1){
////                    System.out.println(ii);
////            }
//
            List<String> list2 = new ArrayList<String>();
            list2.add("2");
            list2.add("22");
            list2.add("3");
            list2.add("7");
            list2.add("8");
        list2.add("22");
//
//
//            List<String> list3 = new ArrayList<String>();
//
//            List<List<String>> ksks = new ArrayList<>();
//            ksks.add(list1);
//            ksks.add(list2);
//            ksks.add(list3);
//            List<String> sjsd = test.retainElementList(ksks);
//            System.out.println("---交集 intersection---");
//            sjsd.parallelStream().forEach(System.out :: println);


            // 交集
            List<String> intersection = list1.stream().filter(item -> list2.contains(item)).collect(Collectors.toList());
            System.out.println("---交集 intersection---");
            intersection.parallelStream().forEach(System.out :: println);



//
//            // 差集 (list1 - list2)
//            List<String> reduce1 = list1.stream().filter(item -> !list2.contains(item)).collect(Collectors.toList());
//            System.out.println("---差集 reduce1 (list1 - list2)---");
//            reduce1.parallelStream().forEach(System.out :: println);
//
//            // 差集 (list2 - list1)
//            List<String> reduce2 = list2.stream().filter(item -> !list1.contains(item)).collect(Collectors.toList());
//            System.out.println("---差集 reduce2 (list2 - list1)---");
//            reduce2.parallelStream().forEach(System.out :: println);
//
//            // 并集
//            List<String> listAll = list1.parallelStream().collect(Collectors.toList());
//            List<String> listAll2 = list2.parallelStream().collect(Collectors.toList());
//            listAll.addAll(listAll2);
//            System.out.println("---并集 listAll---");
//            listAll.parallelStream().forEachOrdered(System.out :: println);
//
//            // 去重并集
//            List<String> listAllDistinct = listAll.stream().distinct().collect(Collectors.toList());
//            System.out.println("---得到去重并集 listAllDistinct---");
//            listAllDistinct.parallelStream().forEachOrdered(System.out :: println);
//
//            System.out.println("---原来的List1---");
//            list1.parallelStream().forEachOrdered(System.out :: println);
//            System.out.println("---原来的List2---");
//            list2.parallelStream().forEachOrdered(System.out :: println);

    }
}
