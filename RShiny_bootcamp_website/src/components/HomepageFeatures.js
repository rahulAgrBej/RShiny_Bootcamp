import React from 'react';
import clsx from 'clsx';
import styles from './HomepageFeatures.module.css';

const FeatureList = [
  {
    title: 'No coding experience required',
    Svg: require('../../static/img/undraw_docusaurus_mountain.svg').default,
    description: (
      <>
        Absolutely no previous computer science or coding experience needed! So you can focus on delivering the analysis and visuals that are important to your work!
      </>
    ),
  },
  {
    title: 'Based in R',
    Svg: require('../../static/img/undraw_docusaurus_tree.svg').default,
    description: (
      <>
        R is one of the most popular languages used in statistical analysis and research. Our whole program is built on R so that you can easily integrate your research visuals into the platforms you build.
      </>
    ),
  },
  {
    title: 'Learn by doing',
    Svg: require('../../static/img/undraw_docusaurus_react.svg').default,
    description: (
      <>
        Learn by actually creating a data analytics platform from start to end.
      </>
    ),
  },
];

function Feature({Svg, title, description}) {
  return (
    <div className={clsx('col col--4')}>
      <div className="text--center">
        <Svg className={styles.featureSvg} alt={title} />
      </div>
      <div className="text--center padding-horiz--md">
        <h3>{title}</h3>
        <p>{description}</p>
      </div>
    </div>
  );
}

export default function HomepageFeatures() {
  return (
    <section className={styles.features}>
      <div className="container">
        <div className="row">
          {FeatureList.map((props, idx) => (
            <Feature key={idx} {...props} />
          ))}
        </div>
      </div>
    </section>
  );
}
