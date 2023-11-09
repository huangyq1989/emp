package com.emp.studentManage.service;

import com.emp.studentManage.entity.Student;
import com.emp.studentManage.entity.StudentCultivate;
import com.emp.systemManage.entity.Page;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;


public interface StudentService {

    List<Student> queryStudentByLike(Student student, Page pages);

    int countStudentByLike(Student student);

    List<Student> queryStudentByCheck(int[] ids);

    int queryAutoId();

    List<Student> queryStudentByEquals(Student student);

    void insertStudent(Student student);

    void updateStudent(Student student);

    void updateStudentsStatus(int[] ids);

    void deleteStudents(int[] ids);

    Map<String,Object> importStudents(String path) throws IOException, SQLException;

    List<StudentCultivate> querySC(StudentCultivate sc);
}