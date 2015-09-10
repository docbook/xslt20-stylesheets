package org.docbook

import org.gradle.api.Project
import org.gradle.api.Plugin

class DocBookPlugin implements Plugin<Project> {
    void apply(Project target) {
        target.task('orgDocBook', type: DocBookTask)
    }
}
