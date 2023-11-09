package test;
import org.apache.log4j.Logger;

public class Answer2 {
    private static Logger log = Logger.getLogger(Answer2.class);

    public static void main(String[] args){
        //总数638个萝卜
        int countNum = getAllNum(8);
        System.out.println("每天挖一半加一条,第8天剩3条,总数为:" + countNum);

        //3天后兔子不够吃
        int whenDay = getDay(countNum);
        System.out.println("每天吃200条," + whenDay + "天后兔子不够吃");
    }

    /*
     * @Description : 根据最后的天数获取萝卜总数
     * @Author : HuangYQ
     * @Date : 2023/10/29 01:50
     * @Param : lastDayNum:最后的天数
     * @return : 萝卜总数
     */
    public static int getAllNum(int lastDayNum){
        int countNum = 0;
        try{
            int residueNum = 3;
            countNum = residueNum;
            if(lastDayNum > 1){
                //最后一天-1,循环前面的几天
                for(int i = lastDayNum - 1; i > 0; i--){
                    //最后数量的*2+2
                    countNum = countNum * 2 + 2;
                }
            }
        }catch (Exception e){
            log.error("程序异常:{}", e);
        }
        return countNum;
    }

    public static int getDay(int countNum){
        int whenDay = 1;
        try{
            int eatNum = 200;
            whenDay = countNum/eatNum;
        }catch (Exception e){
            log.error("程序异常:{}", e);
        }
        return whenDay;
    }
}
