package test.groovy

import com.jenkinslib.service.MavenService
import org.junit.*
import static groovy.test.GroovyAssert.*

class SampleUnitTest {

    @Before
    void setUp() {

        // load toAlphanumeric
        //def pip = loadScript("vars/SamplePipeline.groovy")
    }

    @Test
    public void testBuild() {
        def mavenService = new MavenService()
        def msg = mavenService.build()
        assertEquals "building", msg
    }

    @Test
    public void testTest() {
        def mavenService = new MavenService()
        def msg = mavenService.test()
        assertEquals "testing", msg
    }
}
