package com.emp.studentManage.dao;


import com.emp.studentManage.entity.Student;
import com.emp.studentManage.entity.StudentCultivate;
import com.emp.systemManage.entity.Page;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface StudentDao {

    List<Student> queryStudentByLike(@Param("student") Student student,@Param("pages") Page pages);

    int countStudentByLike(@Param("student") Student student);

    List<Student> queryStudentByCheck(@Param("ids")int[] ids);

    int queryAutoId();

    List<Student> queryStudentByEquals(@Param("student") Student student);

    void insertStudent(Student student);

    void updateStudent(@Param("student") Student student);

    void updateStudentsStatus(@Param("ids")int[] ids);

    void deleteStudents(@Param("ids")int[] ids);

    List<StudentCultivate> querySC(@Param("sc") StudentCultivate sc);

}
