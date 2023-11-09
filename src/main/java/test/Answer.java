package test;


import org.apache.log4j.Logger;

public class Answer {

    private static Logger log = Logger.getLogger(Answer.class);

    public static void main(String[] args){
        Integer[] u = {1,3,4,7,9,10,13,15,19,21,22,27};
        Integer findNum = dbl_linear(u, 5);
        System.out.println("根据下表返回数组中的第N个元素:" + findNum);
    }

    /*
     * @Description : 返回数组中的第N个元素
     * @Author : HuangYQ
     * @Date : 2023/10/29 01:23
     * @Param : u:需要查找的源数据
     * @Param : index:查找的下标
     * @return : Integer
     * @Version : 1.0.0
     */
    public static Integer dbl_linear(Integer[] u, int index){
        Integer findNum = null;
        try{
            boolean flag = true;
            if(u == null || u.length <= 0){
                log.warn("需要查找的源数据不能为空");
                flag = false;
            }
            if(index < 0){
                log.warn("下标不能为负数");
                flag = false;
            }
            if(flag){
                findNum = u[index];
            }
        }catch (IndexOutOfBoundsException e){
            log.error("数组下标越界:{}", e);
        }catch (Exception e){
            log.error("查找异常:{}", e);
        }
        return findNum;
    }
}
