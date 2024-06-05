package com.tngtech.jgiven.testframework;

import org.assertj.core.api.Assertions;

import com.tngtech.jgiven.Stage;
import com.tngtech.jgiven.annotation.ExpectedScenarioState;
import com.tngtech.jgiven.annotation.ProvidedScenarioState;
import com.tngtech.jgiven.report.model.ReportModel;
import com.tngtech.jgiven.tests.TestScenarioRepository.TestScenario;

import java.util.List;

public class WhenTestFramework<SELF extends WhenTestFramework<?>> extends Stage<SELF> {

    @ExpectedScenarioState
    protected List<TestScenario> testScenario;

    @ProvidedScenarioState
    protected ReportModel reportModel;

    @ProvidedScenarioState
    protected TestExecutor executor;

    @ProvidedScenarioState
    private TestExecutionResult testExecutionResult;

    public SELF the_test_is_executed_with(TestFramework framework) {
        Assertions.assertThat(testScenario).as("No matching test scenario found").isNotNull();
        Assertions.assertThat(testScenario).as("No matching test scenario found").isNotEmpty();

        executor = TestExecutor.getExecutor(framework);
        testExecutionResult = executor.execute(testScenario.getFirst().testClass, testScenario.getFirst().testMethod);
        reportModel = testExecutionResult.getReportModel();
        return self();
    }

    public SELF the_test_class_is_executed_with(TestFramework framework) {
        Assertions.assertThat(testScenario).as("No matching test scenario found").isNotNull();

        executor = TestExecutor.getExecutor(framework);
        testExecutionResult = executor.execute(testScenario.getFirst().testClass);
        reportModel = testExecutionResult.getReportModel();
        return self();
    }

    public SELF the_test_is_executed_with_JUnit() {
        return the_test_is_executed_with(TestFramework.JUnit);
    }

    public SELF the_test_is_executed_with_JUnit5() {
        return the_test_is_executed_with(TestFramework.JUnit5);
    }

    public SELF the_test_is_executed_with_TestNG() {
        return the_test_is_executed_with(TestFramework.TestNG);
    }

    public SELF the_test_class_is_executed_with_JUnit() {
        return the_test_class_is_executed_with(TestFramework.JUnit);
    }

    public SELF the_test_class_is_executed_with_JUnit5() {
        return the_test_class_is_executed_with(TestFramework.JUnit5);
    }

}
