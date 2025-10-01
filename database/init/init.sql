-- Create the articles table
CREATE TABLE IF NOT EXISTS articles (
  id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  content TEXT NOT NULL,
  author VARCHAR(100),
  image_url TEXT,
  published_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create an index on published_at for faster sorting
CREATE INDEX idx_articles_published_at ON articles(published_at DESC);

-- Insert seed data
INSERT INTO articles (title, description, content, author, image_url, published_at) VALUES
(
  'Kubernetes 1.30 Released with Enhanced Security Features',
  'The latest version of Kubernetes introduces groundbreaking security improvements and performance optimizations.',
  'Kubernetes 1.30 has been released with significant enhancements to security, including improved pod security standards and enhanced RBAC capabilities. The new version also brings performance improvements in the scheduler and better support for Windows containers. Development teams are encouraged to upgrade to take advantage of these new features. The release includes over 50 enhancements and numerous bug fixes.',
  'Sarah Chen',
  'https://images.unsplash.com/photo-1667372393119-3d4c48d07fc9?w=800',
  NOW() - INTERVAL '2 hours'
),
(
  'Understanding Microservices Architecture in 2025',
  'A comprehensive guide to building scalable applications using microservices patterns.',
  'Microservices architecture has evolved significantly over the years. This article explores the best practices for designing, deploying, and managing microservices in production environments. We cover service mesh technologies, API gateways, and distributed tracing. Learn how companies like Netflix and Amazon leverage microservices to handle millions of requests per second. We also discuss common pitfalls and how to avoid them.',
  'Michael Rodriguez',
  'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=800',
  NOW() - INTERVAL '5 hours'
),
(
  'PostgreSQL 16: What You Need to Know',
  'Exploring the new features and improvements in the latest PostgreSQL release.',
  'PostgreSQL 16 brings exciting new features including logical replication improvements, better query parallelism, and enhanced JSON support. The performance improvements are particularly notable for large-scale applications. This article dives deep into the new SQL/JSON functions, the improved VACUUM process, and the new monitoring capabilities. Database administrators will appreciate the enhanced backup and recovery options.',
  'David Kim',
  'https://images.unsplash.com/photo-1544383835-bda2bc66a55d?w=800',
  NOW() - INTERVAL '1 day'
),
(
  'React 19: The Future of Frontend Development',
  'React 19 introduces server components and new concurrent features that change how we build UIs.',
  'The React team has unveiled React 19 with revolutionary changes to how we think about frontend development. Server Components allow developers to build faster, more efficient applications by moving computation to the server. The new concurrent rendering features provide smoother user experiences. This article covers migration strategies, new hooks, and best practices for adopting React 19 in your projects. We include code examples and performance benchmarks.',
  'Emily Watson',
  'https://images.unsplash.com/photo-1633356122544-f134324a6cee?w=800',
  NOW() - INTERVAL '3 days'
),
(
  'Docker Best Practices for Production',
  'Essential tips for running Docker containers efficiently in production environments.',
  'Running Docker in production requires careful consideration of security, performance, and reliability. This comprehensive guide covers multi-stage builds, proper image layering, security scanning, and resource limits. Learn how to optimize your Dockerfiles, manage secrets securely, and implement proper health checks. We also discuss container orchestration strategies and when to use Docker Compose versus Kubernetes.',
  'James Mitchell',
  'https://images.unsplash.com/photo-1605745341112-85968b19335b?w=800',
  NOW() - INTERVAL '5 days'
),
(
  'CI/CD Pipeline Automation with GitHub Actions',
  'Streamline your development workflow with automated testing and deployment.',
  'GitHub Actions has become the go-to solution for CI/CD pipelines. This tutorial walks through setting up a complete pipeline including automated testing, security scanning, and multi-environment deployments. We cover matrix builds, caching strategies, and integration with cloud providers. Real-world examples demonstrate how to deploy to AWS, Azure, and GCP. The article includes reusable workflow templates you can adapt for your projects.',
  'Lisa Anderson',
  'https://images.unsplash.com/photo-1618401471353-b98afee0b2eb?w=800',
  NOW() - INTERVAL '1 week'
),
(
  'Traefik 3.0: Modern Reverse Proxy and Load Balancer',
  'Discover how Traefik simplifies routing and SSL management in Kubernetes environments.',
  'Traefik 3.0 brings enhanced performance and new features for cloud-native applications. This article explores automatic SSL certificate management with Let''s Encrypt, dynamic configuration updates, and advanced routing rules. Learn how to implement canary deployments, A/B testing, and rate limiting. We provide real-world examples of Traefik configurations for Kubernetes, including IngressRoute definitions and middleware usage. Perfect for DevOps engineers looking to modernize their infrastructure.',
  'Robert Turner',
  'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=800',
  NOW() - INTERVAL '10 days'
),
(
  'Monitoring and Observability in Cloud Native Applications',
  'A deep dive into metrics, logs, and traces for modern distributed systems.',
  'Observability is crucial for maintaining reliable distributed systems. This comprehensive guide covers the three pillars of observability: metrics, logs, and traces. We explore popular tools like Prometheus, Grafana, and Jaeger. Learn how to implement distributed tracing, set up meaningful alerts, and build dashboards that provide actionable insights. The article includes best practices for instrumenting your applications and choosing the right observability stack for your needs.',
  'Amanda Foster',
  'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=800',
  NOW() - INTERVAL '2 weeks'
);

-- Create a function to automatically update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger to automatically update updated_at
CREATE TRIGGER update_articles_updated_at BEFORE UPDATE ON articles
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column(); 