package com.gellert.digitalcatalog.activities;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.Spinner;
import android.widget.TextView;

import com.gellert.digitalcatalog.R;
import com.gellert.digitalcatalog.models.Teacher;

import java.util.ArrayList;
import java.util.List;

public class TeacherActivity extends AppCompatActivity {

    Spinner spinnerSubjectSelect;
    Spinner spinnerClassSelect;
    ListView studentList;
    TextView txtName;
    Teacher teacher;
    int personID;
    CatalogDatabaseHelper catalogDB;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_teacher);

        catalogDB = new CatalogDatabaseHelper(this);
        personID = Integer.valueOf(getIntent().getStringExtra("personID"));
        teacher = getTeacherInfoFromDatabase(personID);

        spinnerSubjectSelect = (Spinner)findViewById(R.id.spinnerSubjectSelect);
        spinnerClassSelect = (Spinner)findViewById(R.id.spinnerClassSelect);
        studentList = (ListView)findViewById(R.id.studentList);
        txtName = (TextView)findViewById(R.id.txtName);


        txtName.setText("Signed in as " + teacher.getName());
        ArrayAdapter<String> subjectListAdapter = new ArrayAdapter<String>(TeacherActivity.this, android.R.layout.simple_spinner_item, teacher.getSubjects());
        spinnerSubjectSelect.setAdapter(subjectListAdapter);
        spinnerSubjectSelect.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                int subjectID = catalogDB.getSubjectID((teacher.getSubjects()).get(position));
                ArrayList<String> classNames = catalogDB.getTeacherClassesForGivenSubject(personID, subjectID);
                ArrayAdapter<String> classListAdapter = new ArrayAdapter<String>(TeacherActivity.this, android.R.layout.simple_spinner_item, classNames);
                spinnerClassSelect.setAdapter(classListAdapter);
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {
            }
        });

        spinnerClassSelect.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                int classID = catalogDB.getClassID(spinnerClassSelect.getSelectedItem().toString());
                ArrayList<String> studentNames = catalogDB.getStudentNames(classID);
                ArrayAdapter<String> studentListAdapter = new ArrayAdapter<String>(TeacherActivity.this, android.R.layout.simple_list_item_1, studentNames);
                studentList.setAdapter(studentListAdapter);
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) { }
        });
    }

    private Teacher getTeacherInfoFromDatabase(int personID) {
        String name = catalogDB.getPersonName(personID);
        ArrayList<String> subjects = catalogDB.getTeacherSubjects(personID);
        return new Teacher(personID, name, subjects);
    }

    private void updateStudentList(String[] studentNames) {
        ArrayAdapter<String> studentListAdapter = new ArrayAdapter<String>(TeacherActivity.this, android.R.layout.simple_list_item_1, studentNames);
        studentList.setAdapter(studentListAdapter);
    }
}
