module ProductsHelper
  def category_slug_for_topic(topic_name)
    category_mapping = {
      '생산성 도구' => 'productivity',
      '노트 앱' => 'productivity',
      '협업 도구' => 'productivity',
      '프로젝트관리' => 'productivity',
      '개발 도구' => 'engineering',
      '개발' => 'engineering',
      '배포' => 'engineering',
      '버전관리' => 'engineering',
      '디자인' => 'design',
      '그래픽' => 'design',
      'UI/UX' => 'design',
      'AI' => 'ai-agents',
      '자동화' => 'ai-agents',
      '챗봇' => 'ai-agents',
      '금융' => 'finance',
      '소셜' => 'social',
      '마케팅' => 'marketing',
      '헬스' => 'health',
      '여행' => 'travel',
      '물리적 제품' => 'physical',
      '음성 AI' => 'voice-ai',
      '이커머스' => 'ecommerce',
      '데이터 분석' => 'data-analysis',
      '노코드' => 'nocode',
      '플랫폼' => 'platforms',
      '확장 도구' => 'addons',
      'Web3' => 'web3',
      '블록체인' => 'web3',
      'LLM' => 'llms',
      '언어 모델' => 'llms'
    }
    
    category_mapping[topic_name] || topic_name.downcase.gsub(/[^a-z0-9]/, '')
  end
  
  def topic_link_tag(topic)
    category_slug = category_slug_for_topic(topic.name)
    
    if category_slug.present?
      link_to products_path(category: category_slug), class: "topic-tag" do
        topic.name
      end
    else
      content_tag :span, topic.name, class: "topic-tag"
    end
  end
  
  def star_rating_display(rating, size: 'medium')
    # rating이 nil이거나 0인 경우 처리
    rating = rating.to_f if rating
    rating ||= 0
    
    star_class = size == 'small' ? 'fa-sm' : ''
    
    content_tag :div, class: "stars #{star_class}" do
      5.times.map do |i|
        filled_class = i < rating ? 'filled' : ''
        content_tag :i, '', class: "fas fa-star #{filled_class}"
      end.join.html_safe
    end
  end
end
