package com.example.insta_story_demo

import androidx.test.rule.ActivityTestRule
import com.example.insta_stotry_demo.MainActivity
import dev.flutter.plugins.integration_test.FlutterTestRunner
import org.junit.Rule
import org.junit.runner.RunWith


@RunWith(FlutterTestRunner::class)
class MainActivityTest {
    @Rule
    val rule = ActivityTestRule(
        MainActivity::class.java, true, false
    )
}
