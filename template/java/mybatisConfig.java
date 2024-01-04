
/**
 * author: {{_author_}}
 * created: {{_lua:os.date('%y.%m.%d %H:%M')_}}
 */

package {{_lua:vim.fn.expand("%:p"):sub(vim.fn.expand('%:p'):find('/src/.*/java/'), -1):gsub('/src/.*/java/', ''):gsub('/' .. vim.fn.expand('%:t'), ''):gsub('/', '.')_}};


import javax.sql.DataSource;

import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.SqlSessionTemplate;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import org.springframework.transaction.annotation.EnableTransactionManagement;

@Configuration
@MapperScan(basePackages="kr.co.ndps.**.dao")
@EnableTransactionManagement
public class {{_file_name_}} {
    @Bean
    public SqlSessionFactory sqlSessionFactory(DataSource dataSource) throws Exception {

        final SqlSessionFactoryBean sessionFactory = new SqlSessionFactoryBean();
        sessionFactory.setDataSource(dataSource);
        PathMatchingResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();
        sessionFactory.setMapperLocations(resolver.getResources("classpath:sqlmap/**/**/*.xml"));
        sessionFactory.setTypeAliasesPackage("kr.co.ndps.eas.vo");
        sessionFactory.setTypeHandlersPackage("kr.co.ndps.eas.vo");

        org.apache.ibatis.session.Configuration configuration = new org.apache.ibatis.session.Configuration();
        configuration.setMapUnderscoreToCamelCase(true);
        configuration.setCallSettersOnNulls(true);
        sessionFactory.setConfiguration(configuration);

        return sessionFactory.getObject();
    }

    @Bean
    public SqlSessionTemplate sqlSessionTemplate(SqlSessionFactory sqlSessionFactory) throws Exception {
        final SqlSessionTemplate sqlSessionTemplate = new SqlSessionTemplate(sqlSessionFactory);
        return sqlSessionTemplate;
    }
}
